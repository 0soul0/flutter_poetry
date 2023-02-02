import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/record/listPage.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:get/get.dart';

class RecordFragment extends StatelessWidget {
  RecordFragment({super.key});

  late RecordController controller;
  late PageController pageController;

  init() {
    controller = Get.put(RecordController());
    controller.queryAll();
    pageController = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        // curve: Curves.easeInBack,
        // loop: true,
        // transformer: new ThreeDTransformer(),
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListPage();
        },
      ),
    );
  }
}
