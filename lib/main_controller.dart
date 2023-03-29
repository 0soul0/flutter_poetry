import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_poetry/data/cache_data.dart';
import 'package:flutter_poetry/domain/dao/poetryDao.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/domain/model/event/msgEvent.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/domain/model/subCategoryModel.dart';
import 'package:flutter_poetry/domain/model/systemInfoModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/widget/small_button_widget.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_poetry/routes/singleton.dart';
import 'package:flutter_poetry/tool/shared_preferences_unit.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'data/network/api.dart';
import 'data/route_api.dart';
import 'data/setting_config.dart';
import 'domain/dao/catalogueDao.dart';
import 'domain/dao/fileDao.dart';
import 'domain/dao/subCategoryDao.dart';
import 'domain/dao/systemInfoDao.dart';
import 'domain/fxDataBaseManager.dart';

/// MainController class representing a init setting of application
class MainController extends BaseController {
  static const String checkConfigTimeKey = "checkConfigTimeKey";
  static const String checkAppVersionKey = "checkAppVersionKey";

  static List<FileModel> allFiles = [];
  static List<FileModel> category = [];

  late SystemInfoDao _systemDao;
  late FileDao _fileDao;
  late PoetryDao _poetryDao;
  late CatalogueDao _categoryDao;
  late SubCategoryDao _subCategoryDao;

  bool updateAllSource = false;

  @override
  Future onInit() async {
    super.onInit();
    await init();
    await requestConfig();
    await initCache();
  }

  init() async {
    TextUnitWidget.textSizeTimes = double.parse(await SharedPreferencesUnit()
        .read(MineController.constSeekValue,
            TextUnitWidget.textSizeTimes.toString()));

    _fileDao = await FxDataBaseManager.fileDao();
    _systemDao = await FxDataBaseManager.systemInfoDao();
    _poetryDao = await FxDataBaseManager.poetryDao();
    _categoryDao = await FxDataBaseManager.categoryDao();
    _subCategoryDao = await FxDataBaseManager.subCategoryDao();
  }

  initCache() async {
    CacheData.languageIndex = int.parse(await SharedPreferencesUnit()
        .read(MineController.constLanguageSelected, "0"));

    allFiles = await _fileDao.queryAll();
    category = allFiles
        .where((element) => element.dbType == CatalogueDao.tableName)
        .toList();
  }

  /// can check config data from network
  canCheckConfigDays(int day) async {
    var oldTime = await SharedPreferencesUnit().read(checkConfigTimeKey, '0');
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    if ((currentTime - int.parse(oldTime)).abs() >= day * 86400000) {
      SharedPreferencesUnit().storage(checkConfigTimeKey, currentTime);
      return true;
    }
    return false;
  }

  /// Request information of config data
  requestConfig() async {
    // if (!await canCheckConfigDays()){
    // Singleton.getEventBusInstance().fire(MsgEvent("loadingDone"));
    // return;
    // }

    //取得config資料
    var item = await Api.getInstance().getReturn(RouteApi.systemInfo);
    if (item == null) {
      Singleton.getEventBusInstance().fire(MsgEvent("loadingDone"));
      return;
    }
    final systemInfo = SystemInfoModel.fromMap(item);
    RouteApi.baseUrl = systemInfo.baseUrl;
    // 檢查app版本
    await checkApplicationVersion();
    //檢查config版本
    await checkConfigVersion(systemInfo);
    //檢查檔案版本
    await checkAndUpdateFilesVersion(systemInfo);

    Singleton.getEventBusInstance().fire(MsgEvent("loadingDone"));
  }

  checkApplicationVersion() async {
    //app版本更新,強制更新資料
    var oldversion =
        await SharedPreferencesUnit().read(checkAppVersionKey, '1.0.0');
    final info = await PackageInfo.fromPlatform();
    String appVersion = info.version;
    if (appVersion != oldversion) {
      updateAllSource = true;
      SharedPreferencesUnit().storage(checkAppVersionKey, appVersion);
    }
  }

  /// check version of config
  ///
  /// @param newConfig Need checked data
  checkConfigVersion(SystemInfoModel newConfig) async {
    List<SystemInfoModel> oldConfig = await _systemDao.queryAll();
    CacheData.resVersion = newConfig.appVersion;
    if (oldConfig.isEmpty ||
        (int.parse(newConfig.appVersion.replaceAll(".", "")) >
            int.parse(oldConfig[0].appVersion.replaceAll(".", "")))) {
      updateAllSource = true;
      showDialog(newConfig.updateContent);
      _systemDao.insertItem(newConfig);
    }
  }

  /// Check version of files. if version of files will upgrade,Update files into locale database
  ///
  /// @param newInfo Need checked data
  checkAndUpdateFilesVersion(SystemInfoModel newInfo) async {
    var len = newInfo.files?.length ?? 0;
    for (int i = 0; i < len; i++) {
      var newFile = newInfo.files?[i] ?? FileModel();

      if (!isFileCanUpdate(newFile)) {
        continue;
      }

      var fileMap = await _fileDao.findFileById(newFile.id);
      var oldV = fileMap?.dataVersion ?? "-1";
      var dataUpdateDone = fileMap?.dataUpdateDone ?? FileModel.keyUpdateUnDone;

      if (isFileVersionUpdate(oldV, newFile.dataVersion, newFile) ||
          dataUpdateDone == FileModel.keyUpdateUnDone ||
          updateAllSource) {
        //更新資料庫版本和是否更新完成設定為false
        await updateFileDownloadStatus(FileModel.keyUpdateUnDone, newFile);

        var items = await Api.getInstance().getArrayReturn(newFile.url,
            progress: (progress) {
          Singleton.getEventBusInstance().fire(MsgEvent("loading", map: {
            "total": len,
            "number": i + 1,
            "progress": progress as double
          }));
        });
        if (items == null) continue;
        // 更新檔案
        switch (newFile.dbType) {
          case PoetryDao.tableName:
            {
              await _poetryDao.deleteByType(items[0]["type"]);
              await _poetryDao.insertItems(List.generate(
                  items.length, (index) => PoetryModel.fromMap(items[index])));
              break;
            }
          case CatalogueDao.tableName:
            {
              await _categoryDao.deleteByType(items[0]["type"]);
              await _categoryDao.insertItems(List.generate(items.length,
                  (index) => CatalogueModel.fromMap(items[index])));
              break;
            }
          case SubCategoryDao.tableName:
            {
              await _subCategoryDao.deleteAll();
              await _subCategoryDao.insertItems(List.generate(items.length,
                  (index) => SubCategoryModel.fromMap(items[index])));
              break;
            }
        }

        //更新資料庫版本和是否更新完成設定為false
        await updateFileDownloadStatus(FileModel.keyUpdateDone, newFile);
        continue;
      }

      Singleton.getEventBusInstance().fire(MsgEvent("loading",
          map: {"total": len, "number": i + 1, "progress": 100.0}));
    }
  }

  /// Update downloaded status of file
  ///
  /// @param status update status of file
  /// @param newFile need updated file
  updateFileDownloadStatus(int status, FileModel newFile) async {
    newFile.dataUpdateDone = status;
    await _fileDao.insertItem(newFile);
  }

  /// Is version of application updated
  ///
  /// @param oldV old version
  /// @param newV new version
  isAppVersionUpdate(String oldV, String newV) {
    if (oldV.isEmpty) {
      newV = "1.0.0";
    }
    final intOldV = int.parse(oldV.replaceAll(".", ""));
    final intNewV = int.parse(newV.replaceAll(".", ""));

    return intNewV > intOldV;
  }

  /// Is version of file updated
  ///
  /// @param oldV old version
  /// @param newV new version
  isFileVersionUpdate(String oldV, String newV, FileModel model) {
    if (oldV.isEmpty) {
      newV = "1";
    }
    final intOldV = int.parse(oldV);
    final intNewV = int.parse(newV);

    if (intOldV >= intNewV) return false;

    switch (model.updates) {
      case FileModel.keyUpdatable:
        {
          return true;
        }
      case FileModel.keyLimitedTimeUpdate:
        {
          if (DateTime.now().compareTo(DateTime.parse(model.updateDate)) > 0) {
            return true;
          }
        }
    }
    return false;
  }

  /// is file can update
  isFileCanUpdate(FileModel fileModel) {
    switch (fileModel.updates) {
      case FileModel.keyNotUpdatable:
        return false;
      case FileModel.keyUpdatable:
        return true;
      case FileModel.keyLimitedTimeUpdate:
        return DateTime.now().microsecondsSinceEpoch >
            DateTime.parse(fileModel.updateDate).microsecondsSinceEpoch;
    }

    return true;
  }

  /// show Dialog for update content
  showDialog(String updateContent) {
    // if (updateContent.isEmpty) return;
    // 在每個第五個計數時，顯示一個對話框
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        title: Column(
          children: [
            Image.asset(
              "assets/icon_rocket_launch.gif",
              width: Dimens.iconSize * 8,
              height: Dimens.iconSize * 8,
            ),
            Text(
              'updateTitle'.tr,
              style: Styles.subTextStyleBlack,
            ),
          ],
        ),
        content: Text(
          updateContent,
          style: Styles.textStyleBlack,
        ),
        actions: [
          Center(
            child: SmallButtonWidget(
              'current'.tr,
              onPressed: () {
                Get.back();
              },
            ),
          )
        ],
      ),
    );
  }
}
