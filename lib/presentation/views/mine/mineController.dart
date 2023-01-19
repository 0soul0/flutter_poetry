import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUntils.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/fontFragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/languageFragment.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/model/itemModel.dart';
import '../../../resource/dimens.dart';

class MineController extends BaseController {
  static const String constLanguageSelected = "constLanguageSelected";
  static const String constSeekValue = "constSeekValue";

  Rx<int> seekValue = 0.obs;
  RxBool seekValueShow = RxBool(false);
  RxList<ItemModel> items = List<ItemModel>.from([]).obs;
  late SharedPreferences prefs;

  @override
  Future onInit() async {
    await init();
    initList();
    getSeekValue();
    super.onInit();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  initList() {
    items.addAll({
      ItemModel(
          id: 0,
          title: "捐款",
          value: "你的支持是我們的動力",
          module: ModuleUtils.frameModule),
      ItemModel(
          id: 1,
          title: "字體大小",
          value: "50",
          onTapFunction: () {
            Get.to(() => FontFragment());
          }),
      ItemModel(
          id: 2,
          title: "語言",
          value: "中文",
          onTapFunction: () {
            Get.to(() => LanguageFragment());
          }),
      ItemModel(
          id: 3,
          title: "聯絡我們",
          onTapFunction: () {
            // Get.to();
          }),
    });
  }

  getSeekValue() async {
    var value = await read(constSeekValue);
    value = value == 0 ? Dimens.textSize.toInt() : value;
    seekValue.value = value;
  }

  setSeekValue(int value) {
    seekValue.value = value;
  }

  storage(String key, int value) async {
    await prefs.setInt(key, value);
  }

  Future<int> read(String key) async {
    return prefs.getInt(key) ?? 0;
  }

  updateItem(int index, ItemModel item) {
    items[index] = item;
  }
}
