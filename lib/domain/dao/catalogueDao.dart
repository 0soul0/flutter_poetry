import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';

import 'baseDao.dart';

@dao
abstract class CatalogueDao extends BaseDao<CatalogueModel> {
  static const tableName = "CatalogueModel";
  @Query('SELECT * FROM $tableName WHERE type = :type')
  Future<List<CatalogueModel>> queryAllByType(int type);

  @Query("DELETE FROM $tableName WHERE type == :type")
  Future<void> deleteByType(int type);
}
