import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/data/settingParameters.dart';
import 'package:flutter_poetry/domain/db/baseDb.dart';
import 'package:flutter_poetry/domain/db/poetryDb.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:get/get.dart';

import '../../../domain/model/poetryModel.dart';
import '../../../routes/appRoutes.dart';
import '../base/baseController.dart';

///  search controller
class SearchController extends BaseController {
  late PoetryDb _poetryDb;
  late TextEditingController textController;

  RxList<CatalogueModel> catalogueItems = List<CatalogueModel>.from([]).obs;
  RxList<PoetryModel> poetryItems = List<PoetryModel>.from([]).obs;

  /// init controller
  @override
  Future<void> onInit() async {
    init();
    await _poetryDb.open();
    // await _catalogDb.open();

    // var catalogData = await _catalogDb.queryAll(limit: 20);
    // var poetryData = await _poetryDb.queryAll();

    // _catalogDb.close();
    _poetryDb.close();

    // addCatalogueModelList(List.generate(catalogData.length, (index) {
    //   return CatalogueModel.fromMap(catalogData[index]);
    // }));
    // addPoetryModelList(List.generate(poetryData.length, (index) {
    //   return PoetryModel.fromMap(poetryData[index]);
    // }));

    super.onInit();
  }

  /// init class
  init() {
    _poetryDb = PoetryDb();
    textController = TextEditingController();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Add catalogue data into rxList
  ///
  /// @param data list of CatalogueModel
  addCatalogueModelList(List<CatalogueModel> data) {
    catalogueItems.addAll(data);
  }

  /// Update catalogue data into rxList
  ///
  /// @param index updated position
  /// @param data updated data
  updateCatalogueModelList(int index, CatalogueModel data) {
    catalogueItems[index] = data;
  }

  /// Add poetry data into rxList
  ///
  /// @param data list of PoetryModel
  addPoetryModelList(List<PoetryModel> data) {
    poetryItems.addAll(data);
  }

  /// Update poetry data into rxList
  ///
  /// @param data list of PoetryModel
  updateAllPoetryModelList(List<PoetryModel> data) {
    poetryItems.clear();
    addPoetryModelList(data);
  }

  resetCatalogueModelList() {
    for (int i = 0; i < catalogueItems.length; i++) {
      catalogueItems[i].type = CatalogueModel.constUNSELECTED;
    }
  }

  setSearchText(String text) {
    textController.text = text;
    search(text);
  }

  /// search data from locale db
  ///
  /// @param search needed search text
  search(String search) async {
    await _poetryDb.open();
    var poetryData = await _poetryDb.search(search);
    _poetryDb.close();
    poetryItems.value = List.generate(poetryData.length, (index) {
      return PoetryModel.fromMap(setDescription(search, poetryData[index]));
    });
  }

  /// set description of poetry
  ///
  /// @param poetryData data of poetry
  /// @return data of poetry that have description
  setDescription(String search,dynamic poetryData) {
    if (poetryData['number'].toString().contains(search) ||
        poetryData['title'].contains(search)) {
      if (!poetryData['refrain'].isEmpty) {
        return returnDescriptionOfSelf(poetryData, 'refrain');
      }

      return returnDescriptionOfSelf(poetryData, 'content');
    }

    if (poetryData['content'].contains(search)) {
      return returnDescriptionOfSection(search,poetryData, 'content');
    }

    if (poetryData['refrain'].indexOf(search)) {
      return returnDescriptionOfSection(search,poetryData, 'refrain');
    }

    if (poetryData['author'].contains(search)) {
      return returnDescriptionOfSelf(poetryData, 'author');
    }

    if (poetryData['category'].indexOf(search)) {
      return returnDescriptionOfSelf(poetryData, 'category');
    }

    if (poetryData['subCategory'].indexOf(search)) {
      return returnDescriptionOfSelf(poetryData, 'subCategory');
    }
  }

  /// return self that description is text of self
  ///
  /// @param poetryData data of poetry
  /// @param key of poetry
  /// @return data of poetry
  returnDescriptionOfSelf(dynamic poetryData,String key) {
    var len = min(SettingParameters.poetryOfDescriptionLong,
        poetryData[key].toString().length);
    final newPoetryData = Map.of(poetryData);
    newPoetryData['description'] = poetryData[key].substring(0, len);
    return Map<String, dynamic>.from(newPoetryData);
  }

  /// return section that description is text of self
  ///
  /// @param poetryData data of poetry
  /// @param key of poetry
  /// @return data of poetry
  returnDescriptionOfSection(String search,dynamic poetryData,String key) {
    var index = poetryData[key].indexOf(search);
    var halfPoetryOfDescriptionLong=((SettingParameters.poetryOfDescriptionLong) / 2).round();
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

  onTapPoetry(PoetryModel item){
    Get.toNamed(AppRoutes.poetryDetail,arguments: item);
  }
}
