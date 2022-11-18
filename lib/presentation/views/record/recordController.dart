import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:get/get.dart';

import '../../../domain/db/recordDb.dart';
import '../../../domain/model/recordModel.dart';

class RecordController extends BaseController {

  late RecordDb _recordDb;

  RxList<RecordModel> recordItems = List<RecordModel>.from([]).obs;

  @override
  Future onInit() async {
    init();
    await fakeData();
    await queryAll();
    super.onInit();
  }

  init() {
    _recordDb = RecordDb();
  }

  queryAll() async{
    await _recordDb.open();
    var maps=await _recordDb.queryAll();

    recordItems.value = List.generate(maps.length, (index){
      return RecordModel.fromMap(maps[index]);
    });

    await _recordDb.close();

  }


  fakeData() async {
    await _recordDb.open();
    await _recordDb.delete();
    for (int i = 0; i < 100; i++) {
      RecordModel model = RecordModel(-1,id: i,title: "詩歌+$i",number: "200$i",description: "gogogo");
      await _recordDb.insert(model.toMap());
    }

    await _recordDb.close();
  }

}
