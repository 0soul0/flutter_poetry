import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  static String sqlFileName = "myDb.sql";
  static int version = 1;

  static const tablePoetry = "poetry";
  static const tableRecord = "record";
  static const tableSystem = "system";
  static const tableFile = "file";
  static const tableCategory= "tableCategory";
  static const tableSubCategory= "tableSubCategory";


  static const createPoetry = '''
        CREATE TABLE IF NOT EXISTS $tablePoetry (
        id TEXT PRIMARY KEY, 
        number INTEGER,
        type INTEGER,  
        title TEXT,
        content TEXT,
        refrain TEXT,
        author TEXT,
        category TEXT,
        subCategory TEXT,
        url TEXT,
        pianoSpectrum TEXT,
        guitarSpectrum TEXT,
        pianoMedia TEXT,
        pianoMedia2 TEXT,
        singMedia TEXT
        );
        ''';
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
  static const createSystem = '''
      CREATE TABLE IF NOT EXISTS $tableSystem (
      id INTEGER PRIMARY KEY, 
      appVersion TEXT
      );
      ''';
  static const createFile = '''
      CREATE TABLE IF NOT EXISTS $tableFile (
      id INTEGER PRIMARY KEY, 
      fileName TEXT,
      dataVersion TEXT,
      url TEXT,
      updateDate TEXT,
      updates TEXT,
      dbType TEXT,
      dataUpdateDone INTEGER
      );
      ''';
  static const createCategory = '''
      CREATE TABLE IF NOT EXISTS $tableCategory (
      id TEXT PRIMARY KEY, 
      category TEXT,
      type TEXT
      );
      ''';
  static const createSubCategory = '''
      CREATE TABLE IF NOT EXISTS $tableSubCategory (
      id TEXT PRIMARY KEY, 
      categoryID TEXT,
      subcategory TEXT,
      startVerseNumber TEXT,
      endVerseNumber TEXT
      );
      ''';

  final String dropPoetry = "DROP TABLE IF EXISTS $tablePoetry";
  final String dropRecord = "DROP TABLE IF EXISTS $tableRecord";
  final String dropSystem = "DROP TABLE IF EXISTS $tableSystem";
  final String dropFile = "DROP TABLE IF EXISTS $tableFile";
  final String dropCategory = "DROP TABLE IF EXISTS $tableCategory";
  final String dropSubCategory = "DROP TABLE IF EXISTS $tableSubCategory";


  late Database _db;

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    String path = "${await getDatabasesPath()}/${SqliteHelper.sqlFileName}";
    Database db = await openDatabase(path,
        version: version, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future close() async {
    if (_db.isOpen) {
      return _db.close();
    }
  }

  void _onCreate(Database db, int newVersion) async {
    myLog("Database _onCreate newVersion:$newVersion");
    var batch = db.batch();
    batch.execute(createPoetry);
    batch.execute(createRecord);
    batch.execute(createSystem);
    batch.execute(createFile);
    batch.execute(createCategory);
    batch.execute(createSubCategory);

    batch.execute("INSERT INTO system (id, appVersion) VALUES (1, '-1.0.0')");
    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    myLog("Database _onUpgrade oldVersion:$oldVersion");
    myLog("Database _onUpgrade newVersion:$newVersion");
    // var batch = db.batch();
    // if(oldVersion == 1){
    //   batch.execute(dropPoetry);
    //   batch.execute(createPoetry);
    // }
    //
    // await batch.commit();
  }
}
