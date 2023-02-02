import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/domain/db/poetryDb.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:get/get.dart';

import '../../../domain/db/recordDb.dart';
import '../../../domain/model/recordModel.dart';
import '../../../routes/appRoutes.dart';

class RecordController extends BaseController {
  late RecordDb _recordDb;
  late PoetryDb _poetryDb;
  RxList<RecordModel> recordItems = List<RecordModel>.from([]).obs;

  @override
  Future onInit() async {
    super.onInit();
    init();
    // initData();
  }

  init() {
    _recordDb = RecordDb();
    _poetryDb = PoetryDb();
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
    PoetryModel poetry = await _poetryDb.query('id = ?', [item.sourceId]);
    Get.toNamed(AppRoutes.poetryDetail, arguments: poetry);
    insertRecordDb(item);
    _poetryDb.close();
  }

  /// insert data to recordDb
  insertRecordDb(RecordModel item) async {
    await _recordDb.open();
    item.updateCreateTime();
    await _recordDb.autoCheckInsertOrUpdateWithId(item.toMap());
    _recordDb.close();
  }
}
