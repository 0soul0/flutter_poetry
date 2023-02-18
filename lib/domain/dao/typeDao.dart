import "package:floor/floor.dart";
import "package:flutter_poetry/domain/model/fileModel.dart";
import "package:flutter_poetry/domain/model/poetryModel.dart";

import "../model/typeModel.dart";
import "baseDao.dart";

@dao
abstract class TypeDao extends BaseDao<TypeModel> {
  static const tableName = "TypeModel";

  @Query("SELECT * FROM $tableName")
  Future<List<TypeModel>> queryAll();
}
