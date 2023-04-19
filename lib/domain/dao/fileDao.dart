import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';

import 'baseDao.dart';

@dao
abstract class FileDao extends BaseDao<FileModel> {
  static const tableName = "FileModel";
  @Query('SELECT * FROM $tableName ORDER BY CAST(id AS INTEGER)')
  Future<List<FileModel>> queryAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<FileModel?> findFileById(String id);

  @Query('SELECT * FROM $tableName WHERE name = :name AND dbType = :dbType')
  Future<FileModel?> findFileByNameWithDbType(String name,String dbType);


  @Query('SELECT * FROM $tableName WHERE dbType = :dbType ORDER BY CAST(id AS INTEGER)')
  Future<List<FileModel>> queryAllByDbType(String dbType);

}
