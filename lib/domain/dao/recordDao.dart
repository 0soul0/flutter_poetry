import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/recordModel.dart';

import 'baseDao.dart';

@dao
abstract class RecordDao extends BaseDao<RecordModel> {
  static const tableName = "RecordModel";
  @Query('SELECT * FROM $tableName ORDER BY createTime DESC LIMIT :page,:count')
  Future<List<RecordModel>> queryPage(int page, int count);

  @Query('SELECT * FROM $tableName WHERE sourceId = :sourceId')
  Future<RecordModel?> queryBySourceId(String sourceId);
}
