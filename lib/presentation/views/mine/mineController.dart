import 'dart:ffi';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/data/settingParameters.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUnit.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/fontFragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/languageFragment.dart';
import 'package:flutter_poetry/tool/sharedPreferencesUnit.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/model/itemModel.dart';
import '../../../resource/dimens.dart';
import '../../../routes/appRoutes.dart';
import '../../../routes/singleton.dart';

class MineController extends BaseController {
  static const String constLanguageSelected = "constLanguageSelected";
  static const String constSeekValue = "constSeekValue";

  Rx<int> seekValue = Dimens.textSize.toInt().obs;
  RxBool seekValueShow = RxBool(false);
  RxList<ItemModel> items = List<ItemModel>.from([]).obs;
  RxList<ItemModel> contact = List<ItemModel>.from([]).obs;
  RxList<ItemModel> language = List<ItemModel>.from([]).obs;
  List<String> selectLanguage = ["中文","English","French"];
  int languageIndex = 0;

  @override
  Future onInit() async {
    await _defaultSeekValue();
    await initList();
    super.onInit();
  }

  initList() async{
    Singleton.getEventBusInstance().on<ItemModel>().listen((event) {
      items.replaceRange(event.id, event.id + 1, [event]);
    });
    languageIndex = int.parse(await read(MineController.constLanguageSelected, "0"));
    bindMineItem();
  }

  bindMineItem() {
    items.clear();
    items.addAll({
      ItemModel(
          id: 0,
          title: "捐款",
          value: "你的支持是我們的動力",
          module: ModuleUtils.frameModule),
      ItemModel(
          id: 1,
          title: "字體大小",
          value: seekValue.value.toString(),
          onTapFunction: () {
            Get.toNamed(AppRoutes.fontFragment);
          }),
      ItemModel(
          id: 2,
          title: "語言",
          value: selectLanguage[languageIndex],
          onTapFunction: () {
            Get.to(() => const LanguageFragment());
          }),
      ItemModel(
          id: 3,
          title: "聯絡我們",
          onTapFunction: () {
            Get.toNamed(AppRoutes.aboutFragment);
          }),
    });
  }

  bindContactItem() {
    contact.clear();
    contact.addAll({
      ItemModel(
          id: 0,
          title: "gmail",
          value: SettingParameters.gmail[0],
          iconGif: "assets/icon_gmail.gif",
          onTapFunction: () {
            _sendEmail(SettingParameters.gmail[0]);
          }),
      ItemModel(
          id: 1,
          title: "instagram",
          value: SettingParameters.ig[0],
          iconGif: "assets/icon_ig.gif",
          onTapFunction: () {
            _launchUrl(Uri.parse(SettingParameters.ig[1]));
          }),
      ItemModel(
          id: 2,
          title: "facebook",
          value: SettingParameters.facebook[0],
          iconGif: "assets/icon_fb.gif",
          onTapFunction: () {
            _launchUrl(Uri.parse(SettingParameters.facebook[1]));
          }),
    });
  }

  bindLanguages(BuildContext context) async {
    language.clear();
    language.addAll([
      ItemModel(
          id: 0,
          title: "中文",
          selected: languageIndex == 0,
          onTapFunction: () {
            storage(MineController.constLanguageSelected, 0);
            items[2].value=selectLanguage[0];
            Phoenix.rebirth(context);
            Get.back();
          }),
      ItemModel(
          id: 1,
          title: "English",
          selected: languageIndex == 1,
          onTapFunction: () {
            storage(MineController.constLanguageSelected, 1);
            items[2].value=selectLanguage[1];
            Phoenix.rebirth(context);
            Get.back();
          }),
      ItemModel(
          id: 2,
          title: "French",
          selected: languageIndex == 2,
          onTapFunction: () {
            storage(MineController.constLanguageSelected, 2);
            items[2].value=selectLanguage[2];
            Phoenix.rebirth(context);
            Get.back();
          }),
    ]);
  }

  /// launch website
  ///
  /// @param url url of website
  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  /// send email to us
  ///
  /// @param email
  _sendEmail(String email) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{'subject': '聯絡問題'}),
    );
    _launchUrl(emailLaunchUri);
  }

  _defaultSeekValue() async {
    var valueTime = double.parse(
        await read(constSeekValue, Dimens.textSizeTimes.toString()));
    setSeekValue(valueTimeToValue(valueTime).toInt());
  }

  setSeekValue(int value) {
    seekValue.value = value;
  }

  double valueToValueTime(double value) {
    return (value / Dimens.textSize).toDouble();
  }

  double valueTimeToValue(double valueTime) {
    return valueTime * Dimens.textSize;
  }

  updateItem(int index, ItemModel item) {
    items[index] = item;
  }

  storage(String key, dynamic value) {
    SharedPreferencesUnit().storage(key, value);
  }

  read(String key, String defaultValue) async {
    return await SharedPreferencesUnit().read(key, defaultValue);
  }
}
