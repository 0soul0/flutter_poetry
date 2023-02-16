import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/domain/dao/poetryDao.dart';
import 'package:flutter_poetry/domain/dao/recordDao.dart';
import 'package:flutter_poetry/domain/fxDataBaseManager.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:get/get.dart';

import '../../../domain/model/recordModel.dart';
import '../../../routes/appRoutes.dart';
import '../../../routes/singleton.dart';

class RecordController extends BaseController {
  late RecordDao _recordDb;
  late PoetryDao _poetryDb;
  final PageController pageController =PageController(initialPage: 1);
  RxList<RecordModel> recordItems = List<RecordModel>.from([]).obs;

  @override
  Future onInit() async {
    await init();
    initData();
    initEvent();
    super.onInit();
  }

  init() async {
    _recordDb = await FxDataBaseManager.recordDao();
    _poetryDb = await FxDataBaseManager.poetryDao();
  }

  initEvent() {
    Singleton.getEventBusInstance().on<RecordModel>().listen((event) {
      queryAll();
    });
  }

  initData() async {
    await queryAll();
  }

  queryAll() async {
    var items = await _recordDb.queryAll(1,20,"createTime DESC");
    recordItems.value = items;
  }

  /// on tap event
  ///
  /// @param item poetryModel of data
  onTapPoetry(RecordModel item) async {
    var poetry = await _poetryDb.query(item.sourceId);
    insertRecordDb(item);
    Get.toNamed(AppRoutes.poetryDetail,
        arguments: poetry);
  }

  /// insert data to recordDb
  insertRecordDb(RecordModel item) async {
    item.updateCreateTime();
    await _recordDb.updateItem(item);
    Singleton.getEventBusInstance().fire(RecordModel(""));
  }
}
