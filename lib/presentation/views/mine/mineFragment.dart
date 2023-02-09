import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/mine/listPage.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:get/get.dart';
import 'package:lifecycle/lifecycle.dart';

import 'mineController.dart';

class MineFragment extends StatefulWidget {
  MineFragment({Key? key}) : super(key: key);
  late MineController controller;
  late PageController pageController;

  @override
  State<MineFragment> createState() => _MineFragmentState();
}

class _MineFragmentState extends State<MineFragment> {
  @override
  void initState() {
    widget.controller = Get.put(MineController());
    widget.pageController = PageController(initialPage: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
          controller: widget.pageController,
          scrollDirection: Axis.horizontal,
          // curve: Curves.easeInBack,
          // loop: true,
          // transformer: new ThreeDTransformer(),
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListPage(controller: widget.controller);
          },
        ),
    );
  }
}
