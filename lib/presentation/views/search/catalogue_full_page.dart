import 'package:flutter/material.dart';
import 'package:flutter_poetry/main_controller.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../domain/model/catalogueModel.dart';
import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../item/catalogue_item.dart';
import '../widget/backIconButton.dart';
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
        TabController(vsync: this, length: MainController.category.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(Dimens.bannerHeight),
        child: Text(""),
      ),

      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                isScrollable: true,
                labelPadding: const EdgeInsets.only(
                    right: Dimens.space, left: Dimens.space),
                padding: EdgeInsets.zero,
                controller: _tabController,
                unselectedLabelColor: AppColor.helperColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppColor.mainColor,
                indicatorColor: AppColor.mainColor,
                indicatorPadding: const EdgeInsets.all(10),
                tabs: MainController.category.map((item) {
                  return Tab(
                    child: TextUnitWidget(
                      item.name.tr,
                    ),
                  );
                }).toList(),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: MainController.category.map((item) {
                    return Container(
                        padding: const EdgeInsets.fromLTRB(
                            Dimens.backgroundMarginLeft,
                            0,
                            Dimens.backgroundMarginRight,
                            0),
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<List<CatalogueModel>>(
                          future:
                              controller.queryAllCatalogue(int.parse(item.id)),
                          builder: (context, snapshot) {
                            return _catalogueList(snapshot);
                          },
                        ));
                  }).toList(),
                ),
              ),
            ],
          ),
          const BackIconButton()
        ],
      ),
    );
  }

  _catalogueList(AsyncSnapshot<List<CatalogueModel>> snapshot) {
    return MasonryGridView.count(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      crossAxisSpacing: Dimens.itemSpace,
      mainAxisSpacing: Dimens.itemSpace,
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        var item = snapshot.data?[index];
        return CatalogueItem(item, () {
          controller.resetCatalogueModelList();

          // item.selectedStatus = CatalogueModel.constSELECTED;
          // controller.updateCatalogue(index, item, false);

          //change search text
          controller.setSearchText(
              "${SearchController.searchCatalogueKey}${SearchController.split}${item?.category}");

          Get.back();
        });
      },
    );
  }
}
