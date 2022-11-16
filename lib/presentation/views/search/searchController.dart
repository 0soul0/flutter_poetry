import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:get/get.dart';

import '../../../domain/db/catalogueDb.dart';

class SearchController extends GetxController {

  RxList<CatalogueModel> items = List<CatalogueModel>.from([]).obs;
  late CatalogueDb db;

  @override
  Future<void> onInit() async {
    debugPrint("onInit");
    db = CatalogueDb();
    await db.open();
    await fakeData();

    List<CatalogueModel> list = [];
    var map = await db.queryAll(limit: 20);
    for (int i = 0; i < map.length; i++) {
      list.add(CatalogueModel(
          id: map[i]["id"], text: map[i]["text"], type: map[i]["type"]));
    }
    db.close();

    addCatalogueModelList(list);
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    debugPrint("onReady");
    super.onReady();
  }

  @override
  void onClose() {
    debugPrint("onClose");
    super.onClose();
  }

  addCatalogueModelList(List<CatalogueModel> model) {
    items.addAll(model);
  }

  updateCatalogueModelList(int index, CatalogueModel model) {
    items[index] = model;
  }

  resetCatalogueModelList() {
    for (int i = 0; i < items.length; i++) {
      items[i].type = CatalogueModel.constUNSELECTED;
    }
  }

  fakeData() async {
    await db.delete();
    for (int i = 0; i < 100; i++) {
      Map<String, dynamic> map = HashMap();
      map.addAll({"id": i, "text": "愛慕 $i-00", "type": "0"});
      await db.insert(map);
    }
  }
}
