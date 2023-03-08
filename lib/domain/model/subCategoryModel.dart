import 'package:floor/floor.dart';

@entity
class SubCategoryModel {
  SubCategoryModel(
      {this.id = "",
      this.categoryID = "",
      this.subcategory = "",
      this.startVerseNumber = -1,
      this.endVerseNumber = -1});

  @primaryKey
  late String id;
  late String categoryID;
  late String subcategory;
  late int startVerseNumber; //開始詩歌
  late int endVerseNumber; //結束詩歌

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryID': categoryID,
      'subcategory': subcategory,
      'startVerseNumber': startVerseNumber,
      'endVerseNumber': endVerseNumber,
    };
  }

  SubCategoryModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? "";
    categoryID = map["categoryID"] ?? "";
    subcategory = map["subcategory"] ?? "";
    startVerseNumber = map["startVerseNumber"] ?? -1;
    endVerseNumber = map["endVerseNumber"] ?? -1;
  }
}
