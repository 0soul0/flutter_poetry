import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/db/sqliteHelper.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:sqflite/sqflite.dart';

import '../model/poetryModel.dart';

class BaseDb {
  BaseDb(this.table);

  late String table;
  final SqliteHelper _sql = SqliteHelper();
  late Database db;

  Future open() async {
    db = await _sql.db;
    await myDbQuery(this, "before");
  }

  Future close() async {
    // await myDbQuery(this, "after");
    _sql.close();
  }

  insert(Map<String, dynamic> m) async {
    return await db.insert(table, m);
  }

  queryAll({int? limit}) async {
    return await db.query(table, limit: limit);
  }

  queryPage(int page, int count, {String? orderBy="id ASC"}) async {
    page =(page-1)*count;
    return await db.rawQuery('SELECT * FROM $table ORDER BY $orderBy LIMIT $page,$count');
  }

  update(Map<String, dynamic> m) async {
    return await db.update(table, m, where: 'id = ?', whereArgs: [m['id']]);
  }

  autoCheckInsertOrUpdateWithId(Map<String, dynamic> m) async {
    var map = await query('id = ?', [m['id']]);
    if (map.length > 0) {
     return await update(m);
    } else {
     return await insert(m);
    }
  }

  autoCheckInsertOrUpdate(
      String where, List<Object?>? whereArgs, Map<String, dynamic> m) async {
    var map = await query(where, whereArgs);
    if (map.length > 0) {
      m['id']=map[0]['id'];
      await update(m);
    } else {
      await insert(m);
    }
  }

  delete({String? where, List<Object?>? whereArgs}) async {
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  query(String where, List<Object?>? whereArgs) async {
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  isExist(String where, List<Object?>? whereArgs) async {
    return await query(where, whereArgs) != null;
  }
}
