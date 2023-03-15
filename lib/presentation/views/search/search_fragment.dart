import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../domain/dao/poetryDao.dart';
import '../../../domain/fxDataBaseManager.dart';
import '../../../main_controller.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../item/utils/moduleUnit.dart';
import '../widget/bannerWidget.dart';
import '../widget/textUnitWidget.dart';
import 'list_page.dart';

class SearchFragment extends StatefulWidget {
  const SearchFragment({super.key});

  @override
  State<SearchFragment> createState() => _SearchFragment();
}

class _SearchFragment extends State<SearchFragment>
    with SingleTickerProviderStateMixin {
  late SearchController controller;
  late PageController pageController;
  TabController? tabController;
  late List<FileModel> types;

  @override
  void initState() {
    controller = Get.put(SearchController());
    pageController = PageController(initialPage: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetData(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return Container();
        types = snapshot.data as List<FileModel>;
        tabController ??= TabController(length: types.length, vsync: this);
        if (tabController == null) return Container();
        return Column(
          children: [
            const BannerWidget(),
            TabBar(
              isScrollable:true,
              labelPadding:const EdgeInsets.only(right: Dimens.space,left: Dimens.space),
              padding: EdgeInsets.zero,
              controller: tabController,
              unselectedLabelColor: AppColor.helperColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColor.mainColor,
              indicatorColor: AppColor.mainColor,
              indicatorPadding: const EdgeInsets.all(10),
              tabs: types.map((item) {
                return Tab(
                  child: TextUnitWidget(
                    item.name.tr,
                  ),
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: types.map((item) {
                  return Container(
                      padding: const EdgeInsets.fromLTRB(
                          Dimens.backgroundMarginLeft,
                          0,
                          Dimens.backgroundMarginRight,
                          0),key: Key(item.id),
                      child: ListPage(item.id));
                }).toList(),
              ),
            ),
            const Divider(
                height: Dimens.moduleDividing,
                thickness: Dimens.moduleDividing,
                color: AppColor.dividerColor),
            Container(
              height: 32,
              decoration: const BoxDecoration(color: AppColor.dividerColor),
              child: _search(context),
            ),
            const Divider(
                height: Dimens.moduleDividing,
                thickness: Dimens.moduleDividing,
                color: AppColor.dividerColor),
          ],
        );
      },
    );
  }

  fetData() async {
    var dao = await FxDataBaseManager.fileDao();
    return await dao.queryAllByDbType(PoetryDao.tableName);
  }

  /// search data
  int page = 1;
  String searchVal = "";

  _search(BuildContext context) {
    return Stack(
      children: [
        TextUnitWidget(
          "searchHelper".tr,
          style: Styles.helperStyle,
        ),
        TextField(
          controller: controller.textController,
          focusNode: controller.commentFocus,
          textAlign: TextAlign.left,
          onChanged: (value) {
            searchVal = value;
            page = 1;
            controller.search(value);
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.backgroundColor,
              hintText: "searchHelper".tr,
              hintStyle: Styles.helperStyle,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.moduleRadius),
                      bottomRight: Radius.circular(Dimens.moduleRadius))),
              enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 0, color: AppColor.dividerColor),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.moduleRadius),
                      bottomRight: Radius.circular(Dimens.moduleRadius))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColor.secondColor),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.moduleRadius),
                      bottomRight: Radius.circular(Dimens.moduleRadius))),
              contentPadding: const EdgeInsets.all(Dimens.itemPaddingSpace_4),
              prefixIcon: const Icon(Icons.search)),
        ),
      ],
    );
  }

}
