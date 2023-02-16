import 'dart:ffi';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_poetry/domain/dao/poetryDao.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/domain/model/event/msgEvent.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/domain/model/subCategoryModel.dart';
import 'package:flutter_poetry/domain/model/systemInfoModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/routes/singleton.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_poetry/tool/sharedPreferencesUnit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'data/data_source/api.dart';
import 'data/routeApi.dart';
import 'domain/dao/catalogueDao.dart';
import 'domain/dao/fileDao.dart';
import 'domain/dao/subCategoryDao.dart';
import 'domain/fxDataBaseManager.dart';
import 'domain/dao/systemInfoDao.dart';

/// MainController class representing a init setting of application
class MainController extends BaseController {
  late SystemInfoDao _systemDao;
  late FileDao _fileDao;
  late PoetryDao _poetryDao;
  late CatalogueDao _categoryDb;
  late SubCategoryDao _subCategoryDb;

  @override
  Future onInit() async {
    super.onInit();
    await init();
    await request();
  }

  init() async {
    Dimens.textSizeTimes = double.parse(await SharedPreferencesUnit()
        .read(MineController.constSeekValue, Dimens.textSizeTimes.toString()));

    _fileDao = await FxDataBaseManager.fileDao();
    _systemDao = await FxDataBaseManager.systemInfoDao();
    _poetryDao = await FxDataBaseManager.poetryDao();
    _categoryDb = await FxDataBaseManager.categoryDao();
    _subCategoryDb = await FxDataBaseManager.subCategoryDao();
  }

  /// Request information of system data
  request() async {
    //取得config資料
    var item = await Api.getInstance().getReturn(RouteApi.systemInfo);
    if (item == null) return;
    final systemInfo = SystemInfoModel.fromMap(item);
    await _systemDao.insertItem(systemInfo);
    //檢查檔案 版本
    await checkAndUpdateFilesVersion(systemInfo);
  }

  /// Check version of files. if version of files will upgrade,Update files into locale database
  ///
  /// @param newInfo Need checked data
  checkAndUpdateFilesVersion(SystemInfoModel newInfo) async {
    var len = newInfo.files?.length ?? 0;

    for (int i = 0; i < len; i++) {
      var newFile = newInfo.files?[i] ?? FileModel();

      var fileMap = await _fileDao.findFileById(newFile.id);
      var oldV = fileMap?.dataVersion ?? "-1";
      var dataUpdateDone = fileMap?.dataUpdateDone ?? FileModel.keyUpdateUnDone;

      if (isFileVersionUpdate(oldV, newFile.dataVersion, newFile) ||
          dataUpdateDone == FileModel.keyUpdateUnDone) {
        //更新資料庫版本和是否更新完成設定為false
        await updateFileDownloadStatus(FileModel.keyUpdateUnDone, newFile);

        var items = await Api.getInstance().getArrayReturn(newFile.url);
        // 更新檔案
        switch (newFile.dbType) {
          case FileModel.keyPoetryDb:
            {
              await _poetryDao.insertItems(List.generate(
                  items.length, (index) => PoetryModel.fromMap(items[index])));
              break;
            }
          case FileModel.keyCategoryDb:
            {
              await _categoryDb.insertItems(List.generate(items.length,
                  (index) => CatalogueModel.fromMap(items[index])));
              break;
            }
          case FileModel.keySubCategoryDb:
            {
              await _subCategoryDb.insertItems(List.generate(items.length,
                  (index) => SubCategoryModel.fromMap(items[index])));
              break;
            }
        }

        //更新資料庫版本和是否更新完成設定為false
        await updateFileDownloadStatus(FileModel.keyUpdateDone, newFile);

        // 更新完成否更新完成設定為true
        Singleton.getEventBusInstance().fire(MsgEvent("update file finish"));
      }
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
}
