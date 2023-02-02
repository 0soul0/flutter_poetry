class CatalogueModel {
  CatalogueModel({this.id = "", this.category = "", this.type = "0"});

  late String id;
  late String category;
  late String type; //0:unselected 1:selected

  static String constSELECTED = "1";
  static String constUNSELECTED = "0";

  bool get selected => (type == constSELECTED);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'type': type,
    };
  }

  CatalogueModel.fromMap(Map<String, dynamic> map) {
    id= map["id"];
    type= map["type"];
    category= map["category"];
  }

}