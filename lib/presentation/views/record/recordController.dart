import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/domain/db/poetryDb.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:get/get.dart';

import '../../../domain/db/recordDb.dart';
import '../../../domain/model/recordModel.dart';
import '../../../routes/appRoutes.dart';
import '../../../routes/singleton.dart';

class RecordController extends BaseController {
  late RecordDb _recordDb;
  late PoetryDb _poetryDb;
  late PageController pageController;
  RxList<RecordModel> recordItems = List<RecordModel>.from([]).obs;

  @override
  Future onInit() async {
    super.onInit();
    init();
    initEvent();
  }

  init() {
    _recordDb = RecordDb();
    _poetryDb = PoetryDb();
    pageController = PageController(initialPage: 1);
  }

  initEvent() {
    Singleton.getEventBusInstance().on<RecordModel>().listen((event) {
      queryAll();
    });
  }

  // initData() async {
  //   await queryAll();
  // }

  queryAll() async {
    await _recordDb.open();
    var maps = await _recordDb.queryPage(1, 20, orderBy: "createTime DESC");

    recordItems.value = List.generate(maps.length, (index) {
      return RecordModel.fromMap(maps[index]);
    });

    await _recordDb.close();
  }

  /// on tap event
  ///
  /// @param item poetryModel of data
  onTapPoetry(RecordModel item) async {
    await _poetryDb.open();
    var poetry = await _poetryDb.query('id = ?', [item.sourceId]);
    insertRecordDb(item);
    _poetryDb.close();
    Get.toNamed(AppRoutes.poetryDetail,
        arguments: PoetryModel.fromMap(poetry[0]));
  }

  /// insert data to recordDb
  insertRecordDb(RecordModel item) async {
    await _recordDb.open();
    item.updateCreateTime();
    await _recordDb.autoCheckInsertOrUpdateWithId(item.toMap());
    _recordDb.close();
    Singleton.getEventBusInstance().fire(RecordModel(""));
  }
}
