import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poetry/data/setting_config.dart';
import 'package:flutter_poetry/domain/dao/fileDao.dart';
import 'package:flutter_poetry/domain/dao/poetryDao.dart';
import 'package:flutter_poetry/domain/fxDataBaseManager.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/domain/model/event/msgEvent.dart';
import 'package:flutter_poetry/domain/model/recordModel.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/dao/catalogueDao.dart';
import '../../../domain/dao/recordDao.dart';
import '../../../domain/model/fileModel.dart';
import '../../../domain/model/poetryModel.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/singleton.dart';
import '../base/baseController.dart';
import '../item/utils/moduleUnit.dart';

///  search controller
class SearchController extends BaseController {

  static const searchCatalogueKey = "c";
  static const split = "://";

  late PoetryDao _poetryDao;
  late FileDao fileDao;
  late CatalogueDao _catalogueDao;
  late RecordDao _recordDao;
  late final TextEditingController textController = TextEditingController();
  String searchVal="";
  RxList<CatalogueModel> catalogueItems = List<CatalogueModel>.from([]).obs;
  RxList<PoetryModel> poetrySearchItems = List<PoetryModel>.from([]).obs;
  RxMap poetryItemsMap = {}.obs;
  Rx<MsgEvent> loadingProgress =
      MsgEvent("loading", map: {"total": 0, "number": 0, "progress": 0}).obs;

  FocusNode commentFocus = FocusNode();
  ScrollController scrollController = ScrollController();

  /// init controller
  @override
  Future<void> onInit() async {
    super.onInit();
    await init();
    await initData();
  }

  /// init class
  init() async {
    _poetryDao = await FxDataBaseManager.poetryDao();
    _catalogueDao = await FxDataBaseManager.categoryDao();
    _recordDao = await FxDataBaseManager.recordDao();
    fileDao = await FxDataBaseManager.fileDao();
  }

  /// init default data
  initData() async {
    Singleton.getEventBusInstance().on<MsgEvent>().listen((event) {
      loadingProgress.value = event;
      queryAllById("0");
      // search("");
    });
    // search("");

    scrollController.addListener(() {
      if (commentFocus.hasFocus) {
        commentFocus.unfocus();
      }
    });
  }

  queryAllById(String id,
      {int page = 0, int count = SettingParameters.pageCount}) async{
    page = page * count;

    List<PoetryModel> items = [];
    items = await _poetryDao.searchType(int.parse(id), page, count);

    for (int i = 0; i < items.length; i++) {
      items[i] = PoetryModel.fromMap(setDescription("", items[i].toMap()));
      if (page != 0 || (i != 0 && items[i - 1].type == items[i].type)) {
        items[i].itemType = ModuleUtils.poetryModel;
      } else {
        items[i].itemType = ModuleUtils.poetryModelWithType;
      }
    }

    if (page == 0) {
      poetryItemsMap[id] = items;
      return;
    }
    var data = poetryItemsMap[id];
    if (items.isNotEmpty) {
      data.addAll(items);
    }
    poetryItemsMap[id]=data;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// query all of category
  Future<List<CatalogueModel>> queryAllCatalogue(int type) async {
    return await _catalogueDao.queryAllByType(type);
  }

  /// Update catalogue data into rxList
  ///
  /// @param index updated position
  /// @param data updated data
  /// @param isUpdateDb is updated catalogue table
  updateCatalogue(int index, CatalogueModel data, bool isUpdateDb) {
    catalogueItems[index] = data;
    if (isUpdateDb) {
      _catalogueDao.updateItem(data);
    }
  }

  resetCatalogueModelList() {
    for (int i = 0; i < catalogueItems.length; i++) {
      catalogueItems[i].selectedStatus = CatalogueModel.constUNSELECTED;
    }
  }

  setSearchText(String text) {
    var data = text;
    textController.text = data;
    search(text);
  }

  /// search data from locale db
  ///
  /// @param search needed search text
  search(String search,
      {int? id, int page = 0, int count = SettingParameters.pageCount}) async {
    page = page * count;
    searchVal=search;
    List<PoetryModel> items = [];
    //過濾數字搜尋到段落

    if (id != null) {
      items = await _poetryDao.searchType(id, page, count);
    } else {
      var file =
          await fileDao.findFileByNameWithDbType(search, PoetryDao.tableName);
      if (file != null) {
        //詩歌 補沖本
        items = await _poetryDao.searchType(int.parse(file.id), page, count);
      } else if (search.contains(searchCatalogueKey + split)) {
        search = search.split(split)[1];
        items = await _poetryDao.searchCategory(search, page, count);
      } else if (int.tryParse(search) == null) {
        items = await _poetryDao.search("%$search%", page, count);
      } else {
        if (page == 0) {
          items = await _poetryDao.searchNumber(search);
        }

        var itemAll =
            await _poetryDao.searchNoContent(search, "%$search%", page, count);
        items.addAll(itemAll);
      }
    }

    for (int i = 0; i < items.length; i++) {
      items[i] = PoetryModel.fromMap(setDescription(search, items[i].toMap()));
      if (page != 0 || (i != 0 && items[i - 1].type == items[i].type)) {
        items[i].itemType = ModuleUtils.poetryModel;
      } else {
        items[i].itemType = ModuleUtils.poetryModelWithType;
      }
    }

    if (page == 0) {
      poetrySearchItems.value = items;
      return;
    }

    if (items.isNotEmpty) {
      poetrySearchItems.addAll(items);
    }
  }

  /// set description of poetry
  ///
  /// @param poetryData data of poetry
  /// @return data of poetry that have description
  setDescription(String search, dynamic poetryData) {
    if (poetryData['number'].toString().contains(search) ||
        poetryData['title'].contains(search)) {
      if (!poetryData['refrain'].isEmpty) {
        return returnDescriptionOfSelf(poetryData, 'refrain');
      }

      return returnDescriptionOfSelf(poetryData, 'content');
    }

    if (poetryData['content'].contains(search)) {
      return returnDescriptionOfSection(search, poetryData, 'content');
    }

    if (poetryData['refrain'].contains(search)) {
      return returnDescriptionOfSection(search, poetryData, 'refrain');
    }

    // if (poetryData['author'].contains(search)) {
    //   return returnDescriptionOfSelf(poetryData, 'author');
    // }
    //
    // if (poetryData['category'].contains(search)) {
    //   return returnDescriptionOfSelf(poetryData, 'category');
    // }
    //
    // if (poetryData['subCategory'].contains(search)) {
    //   return returnDescriptionOfSelf(poetryData, 'subCategory');
    // }

    return returnDescriptionOfSelf(poetryData, 'content');
  }

  /// return self that description is text of self
  ///
  /// @param poetryData data of poetry
  /// @param key of poetry
  /// @return data of poetry
  returnDescriptionOfSelf(dynamic poetryData, String key) {
    var len = min(SettingParameters.poetryOfDescriptionLong,
        poetryData[key].toString().length);
    final newPoetryData = Map.of(poetryData);
    try {
      newPoetryData['description'] = 'content' == key
          ? poetryData[key].substring(1, len)
          : poetryData[key].substring(0, len);
    } catch (e) {
      newPoetryData['description'] = "";
    }

    return Map<String, dynamic>.from(newPoetryData);
  }

  /// return section that description is text of self
  ///
  /// @param poetryData data of poetry
  /// @param key of poetry
  /// @return data of poetry
  returnDescriptionOfSection(String search, dynamic poetryData, String key) {
    var index = poetryData[key].indexOf(search);
    var halfPoetryOfDescriptionLong =
        ((SettingParameters.poetryOfDescriptionLong) / 2).round();
    var startIndex = index - halfPoetryOfDescriptionLong;
    var endLen = 0;
    if (startIndex < 0) {
      endLen = -startIndex;
      startIndex = 0;
    }
    var endIndex = index + halfPoetryOfDescriptionLong;
    var startLen = 0;
    if (endIndex > poetryData[key].length) {
      startLen = endIndex - poetryData[key].length;
      endIndex = poetryData[key].length;
    }

    final newPoetryData = Map.of(poetryData);
    newPoetryData['description'] =
        poetryData[key].substring(startIndex - startLen, endIndex + endLen);
    return Map<String, dynamic>.from(newPoetryData);
  }

  /// on tap event
  ///
  /// @param item poetryModel of data
  onTapPoetry(PoetryModel item) {
    runMyIsolate(item);
    Get.toNamed(AppRoutes.poetryDetail, arguments: item);
  }

  void runMyIsolate(PoetryModel item) async {
    var data = await _recordDao.queryBySourceId(item.id);
    if (data != null) {
      data.updateCreateTime();
      await _recordDao.updateItem(data);
      return;
    }

    await _recordDao.insertItem(RecordModel(item.id,
        id: const Uuid().v4(),
        title: item.title,
        number: item.number,
        description: item.description));
  }
}
