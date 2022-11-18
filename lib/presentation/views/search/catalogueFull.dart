import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_poetry/presentation/views/search/searchController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../domain/model/catalogueModel.dart';
import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../widget/backIcon.dart';
import '../widget/subIconTitle.dart';
import '../item/catalogue_item.dart';

class CatalogueFull extends StatelessWidget {
  CatalogueFull({Key? key}) : super(key: key);
  final SearchController? controllers = Get.find<SearchController>();

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
              const BackIcon()
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
          itemCount: controllers?.catalogueItems.length,
          itemBuilder: (context, index) {
            var item = controllers?.catalogueItems[index];
            return Catalogue_item(item, () {
              if (item == null) return;
              controllers?.resetCatalogueModelList();

              item.type = CatalogueModel.constSELECTED;
              controllers?.updateCatalogueModelList(index, item);

              //change search text
              controllers?.setSearchText(item.text);

              Get.back();
            });
          },
        ));
  }
}
