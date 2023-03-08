import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/search/searchController.dart';
import 'package:get/get.dart';
import '../../../resource/style.dart';
import '../widget/textUnitWidget.dart';
import 'listPage.dart';

class SearchFragment extends StatelessWidget {
  SearchFragment({Key? key}) : super(key: key);

  late SearchController controller;
  late PageController pageController;

  init() {
    controller = Get.put(SearchController());
    pageController = PageController(initialPage: 2);
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
