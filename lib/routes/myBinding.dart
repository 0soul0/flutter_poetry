import 'package:get/get.dart';

class MyBinding extends Bindings {
  MyBinding(this.bindFunction);

  final Function bindFunction;

  @override
  void dependencies() {
    bindFunction();
  }
}
