import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:sqflite/sqflite.dart';

import 'sqliteHelper.dart';

class CatalogueDb {
  final table = "catalogue";
  late Database db;

  open() async {
    String path = "${await getDatabasesPath()}/${SqliteHelper.sqlFileName}";
    db = await openDatabase(path, version: SqliteHelper.version,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $table (
        id INTEGER PRIMARY KEY, 
        text TEXT, 
        type TEXT
        );
        ''');
    });
  }

  close() async => db.close();

  insert(Map<String, dynamic> m) async {
    return await db.insert(table, m);
  }

  queryAll({int? limit}) async {
    return await db.query(table, limit: limit);
  }

  Future update(CatalogueModel m) async {
    return await db.update(table, m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }

  Future<int> delete({String? where, List<Object?>? whereArgs}) async {
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
