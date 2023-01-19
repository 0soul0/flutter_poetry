import 'package:flutter_poetry/tool/extension.dart';
import 'package:get/get.dart';



abstract class BaseController<T> extends FullLifeCycleController  {
  late T arguments;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
    myLog('HomeController - onInit called');
  }

  @override
  void onClose() {
    myLog('HomeController - onClose called');
  }

  @override
  void onReady() {
    myLog('HomeController - onReady called');
  }

}
