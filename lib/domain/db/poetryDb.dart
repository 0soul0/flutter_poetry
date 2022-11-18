import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:sqflite/sqflite.dart';

import '../model/poetryModel.dart';
import 'baseDb.dart';
import 'sqliteHelper.dart';


class PoetryDb extends BaseDb {
  PoetryDb() : super(SqliteHelper.tablePoetry);


  search(String search) async {
    return await db.rawQuery('''SELECT * FROM $table WHERE 
    title LIKE '%$search%' OR
    song LIKE '%$search%' OR
    refrain LIKE '%$search%' OR
    classification LIKE '%$search%'
    ORDER BY type ASC, number ASC
    ''');
  }

  // @override
  // List<PoetryModel> toModelList() => List.generate(maps.length, (index) {
  //       return PoetryModel(
  //           id: maps[index]["id"],
  //           title: maps[index]["title"],
  //           type: maps[index]["type"],
  //           number: maps[index]["number"],
  //           song: maps[index]["song"],
  //           refrain: maps[index]["refrain"],
  //           classification: maps[index]["classification"],
  //           describe: maps[index]["describe"]);
  //     });
}
