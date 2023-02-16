import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/source/baseModel.dart';

@entity
class FileModel extends BaseModel {
  FileModel(
      {this.id = "-1",
      this.fileName = "",
      this.dataVersion = "",
      this.url = "",
      this.updateDate = "",
      this.updates = keyNotUpdatable,
      this.dbType = keyPoetryDb,
      this.dataUpdateDone = keyUpdateUnDone}) : super('');

  static const keyNotUpdatable = "0";
  static const keyUpdatable = "1";
  static const keyLimitedTimeUpdate = "2";
  static const keyUpdateDone = 0;
  static const keyUpdateUnDone = 1;
  static const keySubCategoryDb = "subCategoryDb";
  static const keyCategoryDb = "categoryDb";
  static const keyPoetryDb = "poetryDb";

  @primaryKey
  late String id;
  late String fileName;
  late String dataVersion;
  late String url;
  late String updateDate;
  late String updates; //0 不更新 1更新 2 超過updateDate時間在更新
  late String dbType;
  late int dataUpdateDone;

  factory FileModel.fromMap(Map<String, dynamic> json)
  {
    return FileModel(
      id: json['id'],
      fileName: json['fileName'],
      dataVersion: json['dataVersion'],
      url: json['url'],
      updateDate: json['updateDate'],
      dbType: json['dbType'],
      updates: json['updates'],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'fileName': fileName,
        'dataVersion': dataVersion,
        'url': url,
        'updateDate': updateDate,
        'updates': updates,
        'dbType': dbType,
        'dataUpdateDone': dataUpdateDone
      };
}
