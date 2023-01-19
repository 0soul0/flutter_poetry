import 'package:get/get.dart';

abstract class BaseController<T> extends GetxController {
  late T arguments;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
  }

  @override
  void onClose() {}

  @override
  void onReady() {}
}
