import 'package:flutter/cupertino.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/aboutFragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/fontFragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/languageFragment.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetail.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:flutter_poetry/presentation/views/search/searchController.dart';
import 'package:get/get.dart';

import '../presentation/views/poetry/poetrySpectrum.dart';
import '../presentation/views/search/catalogueFull.dart';
import '../presentation/views/search/searchFragment.dart';
import 'appRoutes.dart';
import 'myBinding.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: AppRoutes.poetryDetail,
        page: () => const PoetryDetail(),
        binding: MyBinding(() {
          Get.lazyPut(() => PoetryDetailController());
        })),

    GetPage(
        name: AppRoutes.poetrySpectrum,
        page: () => const PoetrySpectrum(),
        binding: MyBinding(() {
          Get.lazyPut(() => PoetryDetailController());
        })),
    GetPage(
        name: AppRoutes.catalogueFull,
        page: () => CatalogueFull(),
        binding: MyBinding(() {
          Get.lazyPut(() => SearchController());
        })),

    GetPage(
        name: AppRoutes.fontFragment,
        page: () => const FontFragment(),
        binding: MyBinding(() {
          Get.lazyPut(() => MineController());
        })),

    GetPage(
        name: AppRoutes.aboutFragment,
        page: () => const AboutFragment(),
        binding: MyBinding(() {
          Get.lazyPut(() => MineController());
        })),

    GetPage(
        name: AppRoutes.languageFragment,
        page: () => const LanguageFragment(),
        binding: MyBinding(() {
          Get.lazyPut(() => MineController());
        })),

  ];
}
