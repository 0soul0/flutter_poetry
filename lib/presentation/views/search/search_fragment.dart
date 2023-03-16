import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../domain/dao/poetryDao.dart';
import '../../../domain/fxDataBaseManager.dart';
import '../../../main_controller.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../../../routes/app_routes.dart';
import '../item/utils/moduleUnit.dart';
import '../widget/banner_widget.dart';
import '../widget/text_unit_widget.dart';
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
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(child: body()),
      const Divider(
          height: Dimens.moduleDividing,
          thickness: Dimens.moduleDividing,
          color: AppColor.dividerColor),
      Container(
        height: 20*TextUnitWidget.textSizeTimes,
        decoration: const BoxDecoration(color: AppColor.dividerColor),
        child: _search(context),
      ),
      const Divider(
          height: Dimens.moduleDividing,
          thickness: Dimens.moduleDividing,
          color: AppColor.dividerColor),
    ]);
  }

  body() {
    return Obx(() => controller.loadingProgress.value.msg != "loading"
        ? FutureBuilder(
            future: fetData(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return Container();
              types = snapshot.data as List<FileModel>;
              tabController ??=
                  TabController(length: types.length, vsync: this);
              if (tabController == null) return Container();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BannerWidget(),
                  TabBar(
                    isScrollable: true,
                    labelPadding: const EdgeInsets.only(
                        right: Dimens.space, left: Dimens.space),
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
                                0),
                            key: Key(item.id),
                            child: ListPage(item.id, ListType.list));
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          )
        : Center(
            child: SizedBox(
              height: Dimens.iconSize * 10,
              width: Dimens.iconSize * 10,
              child: Column(
                children: [
                  Image.asset(
                    "assets/icon_electric_guitar_music.gif",
                    height: Dimens.iconSize * 8,
                    width: Dimens.iconSize * 8,
                  ),
                  TextUnitWidget(
                    "${controller.loadingProgress.value.map?["number"]}/${controller.loadingProgress.value.map?["total"]}",
                    style: Styles.helperStyleBlack,
                  )
                ],
              ),
            ),
          ));
  }

  fetData() async {
    var dao = await FxDataBaseManager.fileDao();
    return await dao.queryAllByDbType(PoetryDao.tableName);
  }

  _search(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(textScaleFactor:TextUnitWidget.textSizeTimes );
    // return MediaQuery(data: mqDataNew, child: TextField());
    return Stack(
      children: [
        TextUnitWidget(
          "searchHelper".tr,
          style: Styles.helperStyle,
        ),
        MediaQuery(
          data: mqDataNew,
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.left,
            onTap: () {
              Get.toNamed(AppRoutes.searchAllFragment);
            },
            // onChanged: (value) {
            //   searchVal = value;
            //   page = 1;
            //   controller.search(value);
            // },
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
        ),
      ],
    );
  }

}
