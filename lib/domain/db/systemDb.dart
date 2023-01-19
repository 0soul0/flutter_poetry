import 'package:flutter_poetry/domain/db/sqliteHelper.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'baseDb.dart';

class SystemDb extends BaseDb {
  SystemDb() : super(SqliteHelper.tableSystem);

  updateVersion(String version) async {
    var m = {'id': 1, 'appVersion': version};
    return await db.update(table, m, where: 'id = ?', whereArgs: [m["id"]]);
  }
}
