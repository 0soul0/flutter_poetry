import 'dart:convert';
import 'dart:ffi';
import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:get/get.dart';

import 'source/baseModel.dart';

@entity
class TypeModel extends BaseModel {
  TypeModel(super.status,
      {this.id = "",
      this.name = ""});

  @primaryKey
  late String id;
  late String name;

  @ignore
  late List<FileModel>? files;

  factory TypeModel.fromMap(Map<String, dynamic> json) {
    return TypeModel(json['status'], id:json['id'],name:json['name']);
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name
      };
}
