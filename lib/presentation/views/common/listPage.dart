import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/presentation/views/search/catalogueFull.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer';
import '../components/item/catalogueItem.dart';
import '../components/subIconTitle.dart';
import '../search/searchController.dart';

class ListPage extends StatelessWidget {
   ListPage({this.controller, Key? key}) : super(key: key);

  final SearchController? controller;
  late TextEditingController textController;

  init(){
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: AppColor.backgroundColor,
      child: Column(children: [
        SubIconTitle(AppLocalizations.of(context)!.poetry, Icons.menu_book),
        Divider(
            height: 0,
            thickness: Dimens.lineDividing,
            color: AppColor.dividerColor),
        Visibility(
            visible: controller != null,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(
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
                                Get.to(const CatalogueFull());
                              },
                              child: Text(
                                AppLocalizations.of(context)!.seeMore,
                                style: Styles.helperStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.space,
                        ),
                        Expanded(child: _catalogueList()),
                      ],
                    )),
                Divider(
                    height: Dimens.moduleDividing,
                    thickness: Dimens.moduleDividing,
                    color: AppColor.dividerColor),
              ],
            )),
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: Dimens.textSpace),
          child: _searchResult(),
        )),
        Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
        Container(
          height: 32,
          decoration: BoxDecoration(color: AppColor.dividerColor),
          child: _search(context),
        ),
        Divider(
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
          itemCount: controller?.items.length,
          itemBuilder: (context, index) {
            var item = controller?.items[index];
            return CatalogueItem(item, () {
              if (item == null) return;
              controller?.resetCatalogueModelList();

              item.type = CatalogueModel.constSELECTED;
              controller?.updateCatalogueModelList(index, item);

              textController.text = item.text;

            });
          },
        ));
  }

  _searchResult() {
    return AlignedGridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 1,
      crossAxisSpacing: Dimens.itemSpace,
      mainAxisSpacing: Dimens.itemSpace,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.fromLTRB(Dimens.itemSpace, 2, Dimens.itemSpace, 2),
          padding: EdgeInsets.all(Dimens.itemSpace),
          decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.gray,
                  blurRadius: 2,
                  offset: const Offset(0, 0), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(Dimens.itemRadius / 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "羨慕200-250",
                style: Styles.textStyleBlack,
              ),
              Text(
                "歌詞",
                style: Styles.helperStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  _search(BuildContext context) {
    return TextField(
      controller: textController,
      textAlign: TextAlign.left,
      onChanged: (value) {},
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.backgroundColor,
          hintText: AppLocalizations.of(context)!.searchHelper,
          hintStyle: Styles.helperStyle,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: AppColor.dividerColor),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColor.secondColor),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))),
          contentPadding: EdgeInsets.all(Dimens.itemPaddingSpace_4),
          prefixIcon: const Icon(Icons.search)),
    );
  }
}
