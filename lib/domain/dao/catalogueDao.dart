import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';

import 'baseDao.dart';

@dao
abstract class CatalogueDao extends BaseDao<CatalogueModel> {
  static const tableName = "CatalogueModel";
  @Query('SELECT * FROM $tableName WHERE type = :type')
  Future<List<CatalogueModel>> queryAllByType(int type);
}
