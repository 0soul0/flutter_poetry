abstract class BaseModel {
  BaseModel(this.status);

  late String? status;

  Map<String, dynamic> toMap();
}
