import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_poetry/presentation/views/search/searchController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../domain/model/catalogueModel.dart';
import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../widget/backIconButton.dart';
import '../widget/subIconTitle.dart';
import '../item/catalogue_item.dart';

class CatalogueFull extends GetView<SearchController> {
  const CatalogueFull({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.banner)),
      body: Container(
          padding: const EdgeInsets.fromLTRB(Dimens.backgroundMarginLeft,
              Dimens.textSpace, Dimens.backgroundMarginRight, Dimens.textSpace),
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  SubIconTitle(AppLocalizations.of(context)!.catalogue,
                      Icons.checklist_rtl),
                  Expanded(child: _catalogueList()),
                ],
              ),
              const BackIconButton()
            ],
          )),
    );
  }

  _catalogueList() {
    return Obx(() => AlignedGridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          crossAxisSpacing: Dimens.itemSpace,
          mainAxisSpacing: Dimens.itemSpace,
          itemCount: controller.catalogueItems.length,
          itemBuilder: (context, index) {
            var item = controller.catalogueItems[index];
            return Catalogue_item(item, () {
              controller.resetCatalogueModelList();

              item.type = CatalogueModel.constSELECTED;
              controller.updateCatalogueModelList(index, item);

              //change search text
              controller.setSearchText(item.text);

              Get.back();
            });
          },
        ));
  }
}
