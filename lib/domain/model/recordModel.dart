import 'package:flutter/cupertino.dart';

class RecordModel {
  RecordModel(this.sourceId,
      {this.id = -1, this.title = "", this.number = "", this.description = ""});

  late int id;
  late int sourceId; //foreign key Poetry
  late String title;
  late String number;
  late String description; //搜尋結果的歌詞描述
  String createTime = DateTime.now().toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceId': sourceId,
      'title': title,
      'number': number,
      'description': description,
      'createTime': createTime,
    };
  }

  RecordModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? "";
    sourceId = map["sourceId"] ?? "";
    title = map["title"] ?? "";
    number = map["number"] ?? "";
    description = map["describe"] ?? "";
    createTime = map["createTime"] ?? "";
  }
}
