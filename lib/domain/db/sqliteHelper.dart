import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper{
  static String sqlFileName = "myDb.sql";
  static int version = 1;

  static const tablePoetry = "poetry";
  static const createPoetry = '''
        CREATE TABLE IF NOT EXISTS $tablePoetry (
        id INTEGER PRIMARY KEY, 
        title TEXT, 
        number TEXT, 
        type TEXT, 
        song TEXT, 
        refrain TEXT,
        classification TEXT
        );
        ''';
  final String dropPoetry = "DROP TABLE IF EXISTS $tablePoetry";

  static const tableCatalogue = "catalogue";
  static const createCatalogue = '''
      CREATE TABLE IF NOT EXISTS $tableCatalogue (
      id INTEGER PRIMARY KEY, 
      text TEXT, 
      type TEXT
      );
      ''';
  final String dropCatalogue = "DROP TABLE IF EXISTS $tableCatalogue";

  static const tableRecord = "record";
  static const createRecord = '''
      CREATE TABLE IF NOT EXISTS $tableRecord (
      id INTEGER PRIMARY KEY, 
      sourceId INTEGER, 
      title TEXT,
      number TEXT,
      description TEXT,
      createTime TEXT
      );
      ''';

  final String dropRecord = "DROP TABLE IF EXISTS $tableRecord";

  late Database _db;

  Future<Database> get db async{
    _db = await _initDb();
    return _db;
  }

  _initDb() async{
    debugPrint("open database");
    String path = "${await getDatabasesPath()}/${SqliteHelper.sqlFileName}";
    Database db = await openDatabase(path,version: version,onCreate: _onCreate,onUpgrade: _onUpgrade);
    return db;

  }

  Future close() async {
    return _db.close();
  }

  void _onCreate(Database db, int newVersion) async{
    log("Database _onCreate newVersion:$newVersion");
    var batch = db.batch();
    batch.execute(createPoetry);
    batch.execute(createCatalogue);
    batch.execute(createRecord);
    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion,int newVersion)async{
    log("Database _onUpgrade oldVersion:$oldVersion");
    log("Database _onUpgrade newVersion:$newVersion");
    // var batch = db.batch();
    // if(oldVersion == 1){
    //   batch.execute(dropPoetry);
    //   batch.execute(createPoetry);
    // }
    //
    // await batch.commit();

  }

}
