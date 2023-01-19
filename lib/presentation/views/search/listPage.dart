import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/search/catalogueFull.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/routes/appPages.dart';
import 'package:flutter_poetry/routes/appRoutes.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../item/catalogue_item.dart';
import '../item/splitItem.dart';
import '../item/searchResultItem.dart';
import '../item/utils/moduleUntils.dart';
import '../poetry/poetryDetail.dart';
import '../widget/subIconTitle.dart';
import 'searchController.dart';

class ListPage<T> extends StatelessWidget {
  const ListPage({this.controller, Key? key}) : super(key: key);

  final SearchController? controller;

  init() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Column(children: [
        SubIconTitle(AppLocalizations.of(context)!.poetry, Icons.menu_book),
        const Divider(
            height: 0,
            thickness: Dimens.lineDividing,
            color: AppColor.dividerColor),
        Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(
                    Dimens.backgroundMarginLeft,
                    Dimens.textSpace,
                    Dimens.backgroundMarginRight,
                    Dimens.textSpace),
                height: 104,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.catalogue,
                          style: Styles.textStyleBlack,
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            Get.to(CatalogueFull());
                          },
                          child: Text(
                            AppLocalizations.of(context)!.seeMore,
                            style: Styles.helperStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimens.space,
                    ),
                    Expanded(child: _catalogueList()),
                  ],
                )),
            const Divider(
                height: Dimens.moduleDividing,
                thickness: Dimens.moduleDividing,
                color: AppColor.dividerColor),
          ],
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimens.textSpace),
          child: _searchResult(),
        )),
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
      ]),
    );
  }

  _catalogueList() {
    return Obx(() => AlignedGridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 2,
          crossAxisSpacing: Dimens.itemSpace,
          mainAxisSpacing: Dimens.itemSpace,
          itemCount: controller?.catalogueItems.length,
          itemBuilder: (context, index) {
            var item = controller?.catalogueItems[index];
            return Catalogue_item(item, () {
              if (item == null) return;
              controller?.resetCatalogueModelList();

              item.type = CatalogueModel.constSELECTED;
              controller?.updateCatalogueModelList(index, item);

              //change search text
              controller?.setSearchText(item.text);
            });
          },
        ));
  }

  /// show search result
  _searchResult() {
    return Obx(() => AlignedGridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          crossAxisSpacing: Dimens.itemSpace,
          mainAxisSpacing: Dimens.itemSpace,
          itemCount: controller?.poetryItems.length,
          itemBuilder: (context, index) {
            var lastItem = PoetryModel();
            if (index > 0) {
              lastItem = controller?.poetryItems[index - 1] ?? PoetryModel();
            }
            var item = controller?.poetryItems[index] ?? PoetryModel();

            if (index == 0 || lastItem.type != item.type) {
              return ModuleUtils.bindPoetryItemByModel(
                  item, ModuleUtils.poetryModelWithType, onTapFunction: () {
                controller?.onTapPoetry(item);
              });
            }

            return ModuleUtils.bindPoetryItemByModel(
                item, ModuleUtils.poetryModel, onTapFunction: () {
              controller?.onTapPoetry(item);
            });
          },
        ));
  }

  /// search data
  _search(BuildContext context) {
    return TextField(
      controller: controller?.textController,
      textAlign: TextAlign.left,
      onChanged: (value) {
        controller?.search(value);
      },
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.backgroundColor,
          hintText: AppLocalizations.of(context)!.searchHelper,
          hintStyle: Styles.helperStyle,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: AppColor.dividerColor),
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
    );
  }
}
