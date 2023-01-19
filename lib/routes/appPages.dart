import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetail.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:get/get.dart';

import 'appRoutes.dart';
import 'myBinding.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: AppRoutes.poetryDetail,
        page: () => PoetryDetail(),
        binding: MyBinding(() {
          Get.lazyPut(() => PoetryDetailController());
        })),
  ];
}
