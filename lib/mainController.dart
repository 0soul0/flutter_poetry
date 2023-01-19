import 'package:flutter_poetry/domain/db/fileDb.dart';
import 'package:flutter_poetry/domain/db/poetryDb.dart';
import 'package:flutter_poetry/domain/db/subCategoryDb.dart';
import 'package:flutter_poetry/domain/db/systemDb.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/domain/model/systemInfoModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'data/data_source/api.dart';
import 'data/routeApi.dart';
import 'domain/db/categoryDb.dart';

/// MainController class representing a init setting of application
class MainController extends BaseController {
  final SystemDb _systemDb = SystemDb();
  final FileDb _fileDb = FileDb();
  final PoetryDb _poetryDb = PoetryDb();
  final SubCategoryDb _subCategoryDb = SubCategoryDb();
  final CategoryDb _categoryDb = CategoryDb();

  @override
  Future onInit() async {
    super.onInit();
    await request();
  }

  /// Request information of system data
  request() async {
    return Api.getInstance().get(RouteApi.systemInfo,
        success: (Map<String, dynamic> map) {

      SystemInfoModel systemInfo = SystemInfoModel.fromMap(map);

      checkSystemInfo(systemInfo);
    });
  }

  /// Check version of application and all of version of file
  ///
  /// @param systemInfo Need checked data
  checkSystemInfo(SystemInfoModel systemInfo) async {
    await _systemDb.open();
    await _fileDb.open();
    await _poetryDb.open();
    await _subCategoryDb.open();
    await _categoryDb.open();

    var maps = await _systemDb.queryAll();
    var oldInfo = SystemInfoModel.fromMap(maps[0]);
    final newInfo = systemInfo;

    //檢查app 版本
    if (isAppVersionUpdate(oldInfo.appVersion, newInfo.appVersion)) {
      //更新版本
      await _systemDb.updateVersion(newInfo.appVersion);
    }

    // 檢查檔案 版本
    await checkAndUpdateFilesVersion(newInfo);

    _systemDb.close();
    _poetryDb.close();
    _fileDb.close();
    _subCategoryDb.close();
    _categoryDb.close();
  }

  /// Check version of files. if version of files will upgrade,Update files into locale database
  ///
  /// @param newInfo Need checked data
  checkAndUpdateFilesVersion(SystemInfoModel newInfo) async {
    var len = newInfo.files?.length ?? 0;
    for (int i = 0; i < len; i++) {

      var newFile = newInfo.files?[i] ?? FileModel();
      var fileMap = await _fileDb.query('id = ?', [newFile.id]);
      var oldV = fileMap.length > 0 ? fileMap[0]['dataVersion'] : "-1";
      var dataUpdateDone = fileMap.length > 0
          ? fileMap[0]['dataUpdateDone']
          : FileModel.keyUpdateUnDone;

      if (isFileVersionUpdate(oldV, newFile.dataVersion, newFile) ||
          dataUpdateDone == FileModel.keyUpdateUnDone) {

        //更新資料庫版本和是否更新完成設定為false
        await updateFileDownloadStatus(
            FileModel.keyUpdateUnDone, newFile);
        // 更新檔案
        await Api.getInstance().getArray(newFile.url,
            success: (List<dynamic> list) async {
          for (int i = 0; i < list.length; i++) {
            switch (newFile.dbType) {
              case FileModel.keyPoetryDb:
                {
                  await _poetryDb.autoCheckInsertOrUpdate(list[i]);
                  break;
                }
              case FileModel.keyCategoryDb:
                {
                  await _categoryDb.autoCheckInsertOrUpdate(list[i]);
                  break;
                }
              case FileModel.keySubCategoryDb:
                {
                  await _subCategoryDb.autoCheckInsertOrUpdate(list[i]);
                  break;
                }
            }
          }
          // 更新完成否更新完成設定為true
          // await updateFileDownloadStatus(FileModel.keyUpdateDone, newFile);
        });
      }
    }
  }

  /// Update downloaded status of file
  ///
  /// @param status update status of file
  /// @param newFile need updated file
  updateFileDownloadStatus(int status, FileModel newFile) async {
    newFile.dataUpdateDone = status;
    await _fileDb.autoCheckInsertOrUpdate(newFile.toMap());
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
