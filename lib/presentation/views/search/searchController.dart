import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/domain/db/baseDb.dart';
import 'package:flutter_poetry/domain/db/poetryDb.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:get/get.dart';

import '../../../domain/db/catalogueDb.dart';
import '../../../domain/model/poetryModel.dart';
import '../base/baseController.dart';

///
///  相式 viewmodel
///
///
class SearchController extends BaseController {
  late CatalogueDb _catalogDb;
  final PoetryDb _poetryDb = PoetryDb();
  late TextEditingController textController;

  RxList<CatalogueModel> catalogueItems = List<CatalogueModel>.from([]).obs;
  RxList<PoetryModel> poetryItems = List<PoetryModel>.from([]).obs;

  @override
  Future<void> onInit() async {
    debugPrint("onInit");
    init();
    await _poetryDb.open();
    await _catalogDb.open();

    await fakeData();
    var maps = await _catalogDb.queryAll(limit: 20);
    _catalogDb.close();
    _poetryDb.close();

    addCatalogueModelList(List.generate(maps.length, (index) {
      return CatalogueModel.fromMap(maps[index]);
    }));

    super.onInit();
  }

  init() {
    _catalogDb = CatalogueDb();
    // _poetryDb = PoetryDb();
    textController = TextEditingController();
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
    catalogueItems.addAll(model);
  }

  updateCatalogueModelList(int index, CatalogueModel model) {
    catalogueItems[index] = model;
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

  search(String search) async {
    debugPrint("SearchController $search");
    await _poetryDb.open();
    var maps = await _poetryDb.search(search);
    poetryItems.value = List.generate(maps.length, (index) {
      return PoetryModel.fromMap(maps[index]);
    });
    // await _poetryDb.close();
  }

  fakeData() async {
    await _catalogDb.delete();
    for (int i = 0; i < 100; i++) {
      Map<String, dynamic> map = HashMap();
      map.addAll({"id": i, "text": "愛慕", "type": "0"});
      await _catalogDb.insert(map);
    }

    await _poetryDb.delete();
    for (int i = 0; i < 100; i++) {
      Map<String, dynamic> map = HashMap();
      map.addAll({
        "id": i,
        "title": "詩歌1",
        "type": "0",
        "song": "songsongsongsongsongsongsongsongsongsongsgon",
        "refrain": "refrain",
        "classification": "愛慕"
      });
      await _poetryDb.insert(map);
    }
  }
}
