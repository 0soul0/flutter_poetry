import 'package:flutter_poetry/tool/extension.dart';
import 'package:get/get.dart';

abstract class BaseController<T> extends FullLifeCycleController
    with FullLifeCycleMixin {
  @override
  void onDetached() {
    myLog("onDetached");
  }

  @override
  void onInactive() {
    myLog("onInactive");
  }

  @override
  void onPaused() {
    myLog("onPaused");
  }

  @override
  void onResumed() {
    myLog("onResumed");
  }

  late T arguments;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      arguments = Get.arguments;
    }
  }
}
