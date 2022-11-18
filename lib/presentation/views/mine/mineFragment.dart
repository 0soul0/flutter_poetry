import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/mine/listPage.dart';
import 'package:get/get.dart';

import 'mineController.dart';

class MineFragment extends StatelessWidget {
  MineFragment({super.key});

  late MineController controller;
  late PageController pageController;

  init() {
    controller = Get.put(MineController());
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
          return ListPage(controller: controller);
        },
      ),
    );
  }
}
