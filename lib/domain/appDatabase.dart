import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/dao/catalogueDao.dart';
import 'package:flutter_poetry/domain/dao/recordDao.dart';
import 'package:flutter_poetry/domain/dao/systemInfoDao.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/domain/model/recordModel.dart';
import 'package:flutter_poetry/domain/model/systemInfoModel.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/fileDao.dart';
import 'dao/poetryDao.dart';
import 'dao/subCategoryDao.dart';
import 'model/fileModel.dart';
import 'model/poetryModel.dart';
import 'model/subCategoryModel.dart';

part 'appDatabase.g.dart';

//create: flutter packages pub run build_runner build
//clear: flutter packages pub run build_runner watch

//參考: https://www.jianshu.com/p/dbf5e2115fe5
@Database(version: 1, entities: [
  FileModel,
  SystemInfoModel,
  PoetryModel,
  CatalogueModel,
  SubCategoryModel,
  RecordModel
])
abstract class AppDatabase extends FloorDatabase {
  FileDao get fileDao;

  SystemInfoDao get systemInfoDao;

  PoetryDao get poetryDao;

  CatalogueDao get catalogueDao;

  SubCategoryDao get subCategoryDao;

  RecordDao get recordDao;
}
