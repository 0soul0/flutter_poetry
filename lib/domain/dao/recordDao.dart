
import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/domain/model/recordModel.dart';

import 'baseDao.dart';

@dao
abstract class RecordDao extends BaseDao<RecordModel>{
  static const tableName = "RecordModel";
  @Query('SELECT * FROM $tableName ORDER BY :orderBy LIMIT :page,:count')
  Future<List<RecordModel>> queryAll(int page,int count,String orderBy);

  @Query('SELECT * FROM $tableName WHERE sourceId = :sourceId')
  Future<RecordModel?> queryBySourceId(String sourceId);

}