import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUntils.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/fontFragment.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/model/item.dart';

class MineController extends BaseController {

  static const String constLanguageSelected="languageSelected";

  RxList<Item> items = List<Item>.from([]).obs;
  late SharedPreferences prefs;


  @override
  Future onInit() async {
    init();
    initList();
    super.onInit();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  initList() {
    items.addAll({
      Item(
          id: 0,
          title: "捐款",
          value: "你的支持是我們的動力",
          module: ModuleUtils.frameModule),
      Item(id: 1, title: "字體大小", value: "50", onTapFunction: () {
        // Get.to();
      }),
      Item(id: 2, title: "語言", value: "中文", onTapFunction: () {
        Get.to(() => FontFragment());
      }),
      Item(id: 3, title: "聯絡我們", onTapFunction: () {
        // Get.to();
      }),
    });
  }

  storage(String key, dynamic value) async {
    await prefs.setInt(key, value);
  }

  Future<int> read(String key) async {
    return prefs.getInt(key) ?? -1;
  }

  updateItem(int index, Item item) {
    items[index] = item;
  }
}

