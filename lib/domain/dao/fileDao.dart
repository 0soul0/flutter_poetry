
import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';

import 'baseDao.dart';

@dao
abstract class FileDao extends BaseDao<FileModel>{
  static const tableName = "FileModel";
  @Query('SELECT * FROM $tableName')
  Future<List<FileModel>> queryAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<FileModel?> findFileById(String id);


}