import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:sqflite/sqflite.dart';

import '../model/poetryModel.dart';
import 'baseDb.dart';
import 'sqliteHelper.dart';

class PoetryDb extends BaseDb {
  PoetryDb() : super(SqliteHelper.tablePoetry);

  search(String search) async {
    return await db.rawQuery('''SELECT * FROM $table WHERE 
    number LIKE '%$search%' OR
    title LIKE '%$search%' OR
    content LIKE '%$search%' OR
    refrain LIKE '%$search%' OR
    author LIKE '%$search%' OR
    category LIKE '%$search%' OR
    subCategory LIKE '%$search%' 
    ORDER BY type ASC, number ASC
    ''');
  }

  updateById(Map<String, dynamic> m) async {
    return await db.update(table, m, where: 'id = ?', whereArgs: [m["id"]]);
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
