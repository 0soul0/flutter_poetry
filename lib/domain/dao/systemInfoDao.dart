import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';

import '../model/systemInfoModel.dart';
import 'baseDao.dart';

@dao
abstract class SystemInfoDao extends BaseDao<SystemInfoModel> {
  static const tableName = "SystemInfoModel";
  @Query('SELECT * FROM $tableName')
  Future<List<SystemInfoModel>> queryAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<SystemInfoModel?> findFileById(String id);
}
