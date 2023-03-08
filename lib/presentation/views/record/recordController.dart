import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/domain/dao/poetryDao.dart';
import 'package:flutter_poetry/domain/dao/recordDao.dart';
import 'package:flutter_poetry/domain/fxDataBaseManager.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/model/recordModel.dart';
import '../../../routes/appRoutes.dart';
import '../../../routes/singleton.dart';

class RecordController extends BaseController {
  late RecordDao _recordDao;
  late PoetryDao _poetryDao;
  final PageController pageController = PageController(initialPage: 1);
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RxList<RecordModel> recordItems = List<RecordModel>.from([]).obs;

  List<int> recordItemsType = [];

  @override
  Future onInit() async {
    super.onInit();
    await init();
    initData();
    initEvent();
  }

  init() async {
    _recordDao = await FxDataBaseManager.recordDao();
    _poetryDao = await FxDataBaseManager.poetryDao();
  }

  initEvent() {
    Singleton.getEventBusInstance().on<RecordModel>().listen((event) {
      loadData();
    });
  }

  initData() async {
    await loadData();
  }

  /// query all of data

  /// query data by page
  loadData({int page = 0, int count = 20}) async {
    page = page * count;
    var items = await _recordDao.queryPage(page, count, "createTime DESC");

    if (page == 0) {
      recordItems.value = items;
      return;
    }

    if (items.isNotEmpty) {
      recordItems.addAll(items);
    }
  }

  /// on tap event
  ///
  /// @param item poetryModel of data
  onTapPoetry(RecordModel item) async {
    var poetry = await _poetryDao.query(item.sourceId);
    insertRecordDb(item);
    Get.toNamed(AppRoutes.poetryDetail, arguments: poetry);
  }

  /// insert data to recordDb
  insertRecordDb(RecordModel item) async {
    item.updateCreateTime();
    await _recordDao.updateItem(item);
    Singleton.getEventBusInstance().fire(RecordModel(""));
  }
}
