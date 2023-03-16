import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/about_fragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/font_fragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/language_fragment.dart';
import 'package:flutter_poetry/presentation/views/mine/setting/poetry_list_fragment.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetail.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/presentation/views/search/search_fragment.dart';
import 'package:get/get.dart';

import '../presentation/views/mine/setting/version_fragment.dart';
import '../presentation/views/poetry/poetrySpectrum.dart';
import '../presentation/views/search/catalogue_full_page.dart';
import '../presentation/views/search/search_all_fragment.dart';
import 'app_routes.dart';
import 'my_binding.dart';

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
        page: () => const CatalogueFull(),
        binding: MyBinding(() {
          Get.lazyPut(() => SearchController());
        })),
    GetPage(
        name: AppRoutes.searchAllFragment,
        page: () => SearchAllFragment(),
        binding: MyBinding(() {
          Get.lazyPut(() => SearchController());
        })),

    GetPage(
        name: AppRoutes.versionFragment,
        page: () => const VersionFragment(),
        binding: MyBinding(() {
          Get.lazyPut(() => MineController());
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
    GetPage(
        name: AppRoutes.poetryListFragment,
        page: () => const PoetryListFragment(),
        binding: MyBinding(() {
          Get.lazyPut(() => MineController());
        })),
  ];
}
