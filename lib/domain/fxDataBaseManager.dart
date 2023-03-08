import 'appDatabase.dart';

const dbName = "myDb.db";

class FxDataBaseManager {
  static database() async {
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    return database;
  }

  static fileDao() async {
    final db = await database();
    return db.fileDao;
  }

  static systemInfoDao() async {
    final db = await database();
    return db.systemInfoDao;
  }

  static poetryDao() async {
    final db = await database();
    return db.poetryDao;
  }

  static categoryDao() async {
    final db = await database();
    return db.catalogueDao;
  }

  static subCategoryDao() async {
    final db = await database();
    return db.subCategoryDao;
  }

  static recordDao() async {
    final db = await database();
    return db.recordDao;
  }

  static typeDao() async {
    final db = await database();
    return db.typeDao;
  }
}
