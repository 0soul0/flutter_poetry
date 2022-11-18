class PoetryModel {
  PoetryModel(
      {this.id = 0,
      this.title = "",
      this.number = "",
      this.type = "0",
      this.song = "",
      this.refrain = "",
      this.classification = "",
      this.describe = ""});

  late int id;
  late String title;
  late String number;
  late String type; //0詩歌 1補充本
  late String song;
  late String refrain; //副歌
  late String classification;
  late String describe; //搜尋結果的歌詞描述

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'type': type,
      'song': song,
      'refrain': refrain,
      'classification': classification,
    };
  }

  PoetryModel.fromMap(Map<String, dynamic> map) {
        id= map["id"] ?? "";
        title= map["title"] ?? "";
        type= map["type"] ?? "";
        number= map["number"] ?? "";
        song= map["song"] ?? "";
        refrain= map["refrain"] ?? "";
        classification= map["classification"] ?? "";
        describe= map["describe"] ?? "";
  }
}
