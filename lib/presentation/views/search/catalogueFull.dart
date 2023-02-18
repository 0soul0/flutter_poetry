import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_poetry/mainController.dart';
import 'package:flutter_poetry/presentation/views/search/searchController.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../domain/model/catalogueModel.dart';
import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../widget/backIconButton.dart';
import '../widget/nativeBannerWidget.dart';
import '../widget/subIconTitle.dart';
import '../item/catalogue_item.dart';
import '../widget/textUnitWidget.dart';

class CatalogueFull extends StatefulWidget {
  const CatalogueFull({super.key});

  @override
  State<CatalogueFull> createState() => _CatalogueFull();
}

class _CatalogueFull extends State<CatalogueFull>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SearchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SearchController>();
    _tabController =
        TabController(vsync: this, length: MainController.typeName.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(Dimens.bannerHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.backgroundColor,
          title: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            //设置为Label宽度
            indicatorColor: AppColor.mainColor,
            indicatorPadding: const EdgeInsets.all(10),
            tabs: MainController.typeName.map((item) {
              return Tab(
                child: Text(
                  item.name,
                  style: Styles.tabStyle,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: MainController.typeName.map((item) {
          return Container(
              padding: const EdgeInsets.fromLTRB(
                  Dimens.backgroundMarginLeft,
                  Dimens.textSpace,
                  Dimens.backgroundMarginRight,
                  Dimens.textSpace),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(child: _catalogueList(item.id)),
                    ],
                  ),
                  const BackIconButton()
                ],
              ));
        }).toList(),
      ),
    );
  }

  //
  // return Scaffold(
  // appBar: PreferredSize(
  // preferredSize: const Size.fromHeight(Dimens.bannerHeight),
  // child: NativeBannerWidget(Dimens.bannerHeight),
  // ),
  // body: Container(
  // padding: const EdgeInsets.fromLTRB(Dimens.backgroundMarginLeft,
  // Dimens.textSpace, Dimens.backgroundMarginRight, Dimens.textSpace),
  // width: MediaQuery.of(context).size.width,
  // child: Stack(
  // children: [
  // Column(
  // children: [
  // SubIconTitle(AppLocalizations.of(context)!.catalogue,
  // Icons.checklist_rtl),
  // Expanded(child: _catalogueList()),
  // ],
  // ),
  // const BackIconButton()
  // ],
  // )),
  // );
  _catalogueList(String id) {
    controller.queryAllCatalogue();
    return Obx(() => MasonryGridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          crossAxisSpacing: Dimens.itemSpace,
          mainAxisSpacing: Dimens.itemSpace,
          itemCount: controller.catalogueItems.length,
          itemBuilder: (context, index) {
            var item = controller.catalogueItems[index];

            if (item.type.toString() != id) return Container();

            return CatalogueItem(item, () {
              controller.resetCatalogueModelList();

              // item.selectedStatus = CatalogueModel.constSELECTED;
              // controller.updateCatalogue(index, item, false);

              //change search text
              controller.setSearchText(item.category);

              Get.back();
            });
          },
        ));
  }
}
