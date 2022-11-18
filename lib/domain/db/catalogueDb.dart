import 'package:flutter_poetry/domain/db/sqliteHelper.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'baseDb.dart';


class CatalogueDb extends BaseDb {
  CatalogueDb() : super(SqliteHelper.tableCatalogue);

  // @override
  // List<CatalogueModel> toModelList() => List.generate(maps.length, (index) {
  //       return CatalogueModel(
  //           id: maps[index]["id"],
  //           text: maps[index]["text"],
  //           type: maps[index]["type"]);
  //     });
}
