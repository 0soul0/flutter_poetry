import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/data/cache_data.dart';
import 'package:flutter_poetry/data/setting_config.dart';
import 'package:flutter_poetry/domain/dao/fileDao.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_poetry/tool/shared_preferences_unit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/dao/poetryDao.dart';
import '../../../domain/fxDataBaseManager.dart';
import '../../../domain/model/fileModel.dart';
import '../../../domain/model/itemModel.dart';
import '../../../main_controller.dart';
import '../../../resource/dimens.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/singleton.dart';

class MineController extends BaseController {
  static const String constLanguageSelected = "constLanguageSelected";
  static const String constSeekValue = "constSeekValue";
  static const String constImg = "constImg";

  Rx<int> seekValue = Dimens.textSize.toInt().obs;
  RxBool seekValueShow = RxBool(false);
  RxList<ItemModel> items = List<ItemModel>.from([]).obs;
  RxList<ItemModel> contact = List<ItemModel>.from([]).obs;
  RxList<ItemModel> version = List<ItemModel>.from([]).obs;
  RxList<ItemModel> language = List<ItemModel>.from([]).obs;
  Rx<String> imgFilePath = "".obs;
  RxList<ItemModel> hymn = List<ItemModel>.from([]).obs;
  List<String> selectLanguage = ["中文", "English", "French"];
  int languageIndex = 0;
  late FileDao _fileDao;

  @override
  Future onInit() async {
    super.onInit();
    await init();
    await defaultSeekValue();
    await initList();
    initImg();
  }

  init() async {
    _fileDao = await FxDataBaseManager.fileDao();
  }

  initList() async {
    Singleton.getEventBusInstance().on<ItemModel>().listen((event) {
      items.replaceRange(event.id, event.id + 1, [event]);
    });
    languageIndex =
        int.parse(await read(MineController.constLanguageSelected, "0"));
    bindMineItem();
  }

  bindMineItem() {
    items.clear();
    items.addAll({
      // ItemModel(
      //     id: 0,
      //     title: "denote".tr,
      //     value: "你的支持是我們的動力",
      //     module: ModuleUtils.frameModule),
      ItemModel(
          id: 1,
          title: "textSize".tr,
          value: seekValue.value.toString(),
          onTapFunction: () {
            Get.toNamed(AppRoutes.fontFragment);
          }),
      // ItemModel(
      //     id: 2,
      //     title: "language".tr,
      //     value: selectLanguage[languageIndex],
      //     onTapFunction: () {
      //       Get.to(() => const LanguageFragment());
      //     }),
      ItemModel(
          id: 3,
          title: "poetryList".tr,
          onTapFunction: () {
            Get.toNamed(AppRoutes.poetryListFragment);
          }),
      ItemModel(
          id: 4,
          title: "contactUs".tr,
          onTapFunction: () {
            Get.toNamed(AppRoutes.aboutFragment);
          }),
      ItemModel(
          id: 5,
          title: "version".tr,
          onTapFunction: () {
            Get.toNamed(AppRoutes.versionFragment);
          }),
    });
  }

  bindVersionItem() {
    version.clear();
    var canUpdate = CacheData.statusVersion?.canUpdate??false;
    var url = Uri.parse(CacheData.statusVersion?.appStoreLink??"");
    version.addAll({
      ItemModel(
          id: 0,
          title: "resVersion".tr,
          value: CacheData.resVersion,
          iconGif: "assets/icon_book.gif",
          onTapFunction: () {}),
      ItemModel(
          id: 1,
          title: "localVersion".tr,
          text:  canUpdate?"update".tr:"",
          value: CacheData.statusVersion?.localVersion ?? "1.0.0",
          iconGif: Platform.isAndroid
              ? "assets/icon_android.gif"
              : "assets/icon_apple.gif",
          onTapFunction: () async {
            if(!canUpdate) return;
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          }),
      // ItemModel(
      //     id: 1,
      //     title: "instagram",
      //     value: SettingParameters.ig[0],
      //     iconGif: "assets/icon_ig.gif",
      //     onTapFunction: () {
      //       _launchUrl(Uri.parse(SettingParameters.ig[1]));
      //     }),
      // ItemModel(
      //     id: 2,
      //     title: "facebook",
      //     value: SettingParameters.facebook[0],
      //     iconGif: "assets/icon_fb.gif",
      //     onTapFunction: () {
      //       _launchUrl(Uri.parse(SettingParameters.facebook[1]));
      //     }),
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
      // ItemModel(
      //     id: 1,
      //     title: "instagram",
      //     value: SettingParameters.ig[0],
      //     iconGif: "assets/icon_ig.gif",
      //     onTapFunction: () {
      //       _launchUrl(Uri.parse(SettingParameters.ig[1]));
      //     }),
      // ItemModel(
      //     id: 2,
      //     title: "facebook",
      //     value: SettingParameters.facebook[0],
      //     iconGif: "assets/icon_fb.gif",
      //     onTapFunction: () {
      //       _launchUrl(Uri.parse(SettingParameters.facebook[1]));
      //     }),
    });
  }

  initImg() async {
    String path =await read(constImg, "");
    imgFilePath.value = path;
  }

  Future getImage() async {
    final pickedFile =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile==null){
      return;
    }
    imgFilePath.value = pickedFile.path;
    storage(constImg, pickedFile.path);
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
            items[2].value = selectLanguage[0];
            Phoenix.rebirth(context);
            Get.back();
          }),
      ItemModel(
          id: 1,
          title: "English",
          selected: languageIndex == 1,
          onTapFunction: () {
            storage(MineController.constLanguageSelected, 1);
            items[2].value = selectLanguage[1];
            Phoenix.rebirth(context);
            Get.back();
          }),
      ItemModel(
          id: 2,
          title: "French",
          selected: languageIndex == 2,
          onTapFunction: () {
            storage(MineController.constLanguageSelected, 2);
            items[2].value = selectLanguage[2];
            Phoenix.rebirth(context);
            Get.back();
          }),
    ]);
  }

  bindHymn() async {
    hymn.clear();
    var files = MainController.allFiles
        .where((element) => element.dbType == PoetryDao.tableName)
        .toList();
    for (var i = 0; i < files.length; i++) {
      FileModel item = files[i];
      hymn.addAll({
        ItemModel(
            id: int.parse(item.id),
            title: item.name.tr,
            value: item.dataUpdateDone.toString(),
            onTapFunction: () {})
      });
    }
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

  defaultSeekValue() async {
    var valueTime = double.parse(
        await read(constSeekValue, TextUnitWidget.textSizeTimes.toString()));
    setSeekValue(valueTimeToValue(valueTime).toInt());
    return valueTime;
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
