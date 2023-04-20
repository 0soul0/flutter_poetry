import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:get/get.dart';

import '../../../domain/dao/poetryDao.dart';
import '../../../domain/fxDataBaseManager.dart';
import '../../../resource/dimens.dart';
import '../../../routes/app_routes.dart';
import '../widget/text_unit_widget.dart';
import 'list_page.dart';

class SearchFragment extends StatefulWidget {
  const SearchFragment({super.key});

  @override
  State<SearchFragment> createState() => _SearchFragment();
}

class _SearchFragment extends State<SearchFragment>
    with SingleTickerProviderStateMixin {
  late MySearchController controller;
  late PageController pageController;
  TabController? tabController;
  late List<FileModel> types;

  @override
  void initState() {
    controller = Get.put(MySearchController());
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
        height: 32 * TextUnitWidget.textSizeTimes,
        decoration: const BoxDecoration(color: AppColor.dividerColor),
        child: _search(context),
      ),
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
                  // const BannerWidget(),
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
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimens.textSize16,
                    ),
                    indicatorPadding: const EdgeInsets.all(10),
                    tabs: types.map((item) {
                      return Tab(
                        child: TextUnitWidget(
                          item.getName(),
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
                    style: Theme.of(context).textTheme.displayMedium,
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
    final mqDataNew =
        mqData.copyWith(textScaleFactor: TextUnitWidget.textSizeTimes);
    // return MediaQuery(data: mqDataNew, child: TextField());
    return Stack(
      children: [
        TextUnitWidget(
          "searchHelper".tr,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        MediaQuery(
          data: mqDataNew,
          child: TextField(
            readOnly: true,
            textAlign: TextAlign.left,
            onTap: () {
              controller.page.value="search";
              Get.toNamed(AppRoutes.searchAllFragment);
            },
            // onChanged: (value) {
            //   searchVal = value;
            //   page = 1;
            //   controller.search(value);
            // },
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.background,
                hintText: "searchHelper".tr,
                hintStyle: Theme.of(context).textTheme.displaySmall,
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
                    borderSide:
                        BorderSide(width: 1, color: AppColor.secondColor),
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
