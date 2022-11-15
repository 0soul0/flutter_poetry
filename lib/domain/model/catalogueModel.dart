import 'dart:ffi';

class CatalogueModel {
  CatalogueModel({this.id = 1, this.text = "", this.type = "0"});

  final int id;
  final String text;
  String type; //0:unselected 1:selected

  static String constSELECTED ="1";
  static String constUNSELECTED ="0";

  bool get selected => (type == constSELECTED);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type,
    };
  }
}
