import "package:floor/floor.dart";
import "package:flutter_poetry/domain/model/fileModel.dart";
import "package:flutter_poetry/domain/model/poetryModel.dart";

import "baseDao.dart";

@dao
abstract class PoetryDao extends BaseDao<PoetryModel> {
  static const tableName = "PoetryModel";

  @Query("SELECT * FROM $tableName")
  Future<List<PoetryModel>> queryAll();

  @Query("SELECT * FROM $tableName WHERE id = :id")
  Future<PoetryModel?> query(String id);

  @Query("SELECT * FROM $tableName WHERE number LIKE :str OR title LIKE :str "
      "OR content LIKE :str "
      "OR refrain LIKE :str "
      "OR author LIKE :str "
      "OR category LIKE :str "
      "OR subCategory LIKE :str "
      "ORDER BY type ASC, number ASC "
      "LIMIT :page,:count")
  Future<List<PoetryModel>> search(String str, int page, int count);

  @Query(
      "SELECT * FROM $tableName WHERE number != :number AND number LIKE :str OR title LIKE :str "
      "OR author LIKE :str "
      "OR category LIKE :str "
      "OR subCategory LIKE :str "
      "ORDER BY type ASC, number ASC "
      "LIMIT :page,:count")
  Future<List<PoetryModel>> searchNoContent(
      String number, String str, int page, int count);

  @Query("SELECT * FROM $tableName WHERE category LIKE :str "
      "OR subCategory LIKE :str "
      "ORDER BY type ASC, number ASC "
      "LIMIT :page,:count")
  Future<List<PoetryModel>> searchCategory(String str, int page, int count);

  @Query("SELECT * FROM $tableName WHERE number == :str "
      "ORDER BY type ASC, number ASC ")
  Future<List<PoetryModel>> searchNumber(String str);
}
