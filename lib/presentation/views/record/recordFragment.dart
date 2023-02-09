import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/record/listPage.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:get/get.dart';

import '../../../domain/model/recordModel.dart';
import '../../../routes/singleton.dart';

class RecordFragment extends StatelessWidget {
  RecordFragment({super.key});

  late RecordController controller;

  init() {
    controller = Get.put(RecordController());
    Singleton.getEventBusInstance().fire(RecordModel(""));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      body: PageView.builder(
        controller: controller.pageController,
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
