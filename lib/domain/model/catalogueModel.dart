import 'package:floor/floor.dart';

@entity
class CatalogueModel {
  CatalogueModel(
      {this.id = "",
      this.category = "",
      this.selectedStatus = "0",
      this.type = 0});

  @primaryKey
  late String id;
  late String category;
  late String selectedStatus; //0:unselected 1:selected
  late int type;

  static String constSELECTED = "1";
  static String constUNSELECTED = "0";

  bool get selected => (selectedStatus == constSELECTED);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'selectedStatus': selectedStatus,
      'type': type,
    };
  }

  CatalogueModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    selectedStatus = map["selectedStatus"] ?? "0";
    category = map["category"] ?? "";
    type = map["type"] ?? 0;
  }
}
