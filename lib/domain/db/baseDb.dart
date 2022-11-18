import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/db/sqliteHelper.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:sqflite/sqflite.dart';

import '../model/poetryModel.dart';

class BaseDb {
  BaseDb(this.table);

  late String table;
  late SqliteHelper _sql;
  late Database db;

  // static final BaseDb _instance = BaseDb.internal();
  //
  // static BaseDb get instance => _instance;
  //
  // BaseDb.internal() {
  //   _sql = SqliteHelper();
  // }

  Future open() async {
    _sql = SqliteHelper();
    db = await _sql.db;
  }

  Future close() async => _sql.close();

  insert(Map<String, dynamic> m) async {
    return await db.insert(table, m);
  }

  queryAll({int? limit}) async {
    return await db.query(table, limit: limit);
  }

  update(Map<String, dynamic> m) async {
    return await db.update(table, m, where: 'id = ?', whereArgs: [m["id"]]);
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
