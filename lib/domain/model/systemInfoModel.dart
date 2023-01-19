import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:get/get.dart';

import 'source/baseModel.dart';

class SystemInfoModel extends BaseModel {
  SystemInfoModel(super.status, this.appVersion, this.baseUrl,
      this.updateContent, this.files);

  late String appVersion;
  late String? baseUrl;
  late String? updateContent;
  late List<FileModel>? files;

  factory SystemInfoModel.fromMap(Map<String, dynamic> json) {
    List<FileModel> files = [];
    if (json['files'] != null) {
      files = (json['files'] as List)
          .map((data) => FileModel.fromMap(data))
          .toList();
    }

    return SystemInfoModel(json['status'], json['appVersion'], json['baseUrl'],
        json['updateContent'], files);
  }

  Map<String, dynamic> toMap() => {
        'appVersion': appVersion,
        'baseUrl': baseUrl,
        'updateContent': updateContent,
        'file': files,
      };
}
