import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';

import 'source/baseModel.dart';

@entity
class SystemInfoModel extends BaseModel {
  SystemInfoModel(super.status,
      {this.id = "",
      this.appVersion = "",
      this.baseUrl = "",
      this.updateContent = "",
      this.files});

  @primaryKey
  late String id;
  late String appVersion;
  late String baseUrl;
  late String updateContent;

  @ignore
  late List<FileModel>? files;

  factory SystemInfoModel.fromMap(Map<String, dynamic> json) {
    List<FileModel> files = [];
    if (json['files'] != null) {
      files = (json['files'] as List)
          .map((data) => FileModel.fromMap(data))
          .toList();
    }

    return SystemInfoModel(json['status'],
        id: json['id'],
        appVersion: json['appVersion'],
        baseUrl: json['baseUrl'],
        updateContent: json['updateContent'],
        files: files);
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'appVersion': appVersion,
        'baseUrl': baseUrl,
        'updateContent': updateContent,
        'file': files,
      };
}
