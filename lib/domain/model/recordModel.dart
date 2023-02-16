import 'package:floor/floor.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';

@entity
class RecordModel extends PoetryModel{
  RecordModel(this.sourceId,
      {String id = "", String title = "", int number = -1, String description=""}):super(id:id,number:number,title: title,description: description);

  late String sourceId; //foreign key Poetry
  String createTime = DateTime.now().toString();

  updateCreateTime(){
    createTime = DateTime.now().toString();
  }

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
    number = map["number"] ?? -1;
    description = map["description"] ?? "";
    createTime = map["createTime"] ?? "";
  }
}
