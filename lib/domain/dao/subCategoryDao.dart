import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/subCategoryModel.dart';

import 'baseDao.dart';

@dao
abstract class SubCategoryDao extends BaseDao<SubCategoryModel> {
  static const tableName = "SubCategoryModel";
  @Query('SELECT * FROM $tableName')
  Future<List<SubCategoryModel>> queryAll();
}
