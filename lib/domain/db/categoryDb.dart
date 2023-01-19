import 'package:flutter_poetry/domain/db/sqliteHelper.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'baseDb.dart';

class CategoryDb extends BaseDb {
  CategoryDb() : super(SqliteHelper.tableCategory);
}
