import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_poetry/presentation/views/search/searchController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../domain/model/catalogueModel.dart';
import '../../../resource/dimens.dart';
import '../components/item/catalogueItem.dart';
import '../components/subIconTitle.dart';


class CatalogueFull extends StatelessWidget {
  const CatalogueFull({this.controller, Key? key}) : super(key: key);

  final SearchController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.banner)),
      body: Container(
          padding: EdgeInsets.fromLTRB(Dimens.backgroundMarginLeft,
              Dimens.textSpace, Dimens.backgroundMarginRight, Dimens.textSpace),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SubIconTitle(
                  AppLocalizations.of(context)!.catalogue, Icons.checklist_rtl),
              Expanded(child: _catalogueList()),
            ],
          )),
    );
  }
  _catalogueList() {
    return Obx(()=>AlignedGridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      crossAxisSpacing: Dimens.itemSpace,
      mainAxisSpacing: Dimens.itemSpace,
      itemCount: controller?.items.length,
      itemBuilder: (context, index) {
        var item = controller?.items[index];
        return CatalogueItem(item, () {
          if (item == null) return;
          controller?.resetCatalogueModelList();

          item.type = CatalogueModel.constSELECTED;
          controller?.updateCatalogueModelList(index, item);

          Get.back();
        });
      },
    ));
  }
}

