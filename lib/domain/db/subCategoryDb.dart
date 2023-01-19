import 'package:flutter_poetry/domain/db/sqliteHelper.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'baseDb.dart';

class SubCategoryDb extends BaseDb {
  SubCategoryDb() : super(SqliteHelper.tableSubCategory);
}
