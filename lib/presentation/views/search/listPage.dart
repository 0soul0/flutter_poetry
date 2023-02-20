import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/mainController.dart';
import 'package:flutter_poetry/presentation/views/widget/touchUnitWidget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/routes/appRoutes.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../item/utils/moduleUnit.dart';
import '../widget/emptyPageWidget.dart';
import '../widget/subIconTitle.dart';
import '../widget/textUnitWidget.dart';
import 'searchController.dart';

class ListPage<T> extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);

  final SearchController controller = Get.find<SearchController>();
  int page = 1;
  String searchVal = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              SubIconTitle(
                  "poetry".tr, Icons.menu_book),
              Expanded(child: Container()),
              Container(
                margin:
                    const EdgeInsets.only(right: Dimens.backgroundMarginRight),
                child: TouchUnitWidget(
                  onTapDelay: () {
                    Get.toNamed(AppRoutes.catalogueFull);
                  },
                  child: TextUnitWidget("catalogue".tr,
                      style: Styles.subTitleStyleMainColor),
                ),
              )
            ],
          ),
          const Divider(
              height: 0,
              thickness: Dimens.lineDividing,
              color: AppColor.dividerColor),
          Column(
            children: const [
              Divider(
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
        ],
      ),
    );
  }

  /// show search result
  _searchResult() {
    return Obx(() => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: false,
          enablePullUp: true,
          header: const WaterDropHeader(),
          footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            completeDuration: Duration(milliseconds: 500),
          ),
          onLoading: () async {
            controller.search(searchVal, page: page);
            page++;
            controller.refreshController.loadComplete();
          },
          child: AlignedGridView.count(
            controller: controller.scrollController,
            scrollDirection: Axis.vertical,
            crossAxisCount: 1,
            crossAxisSpacing: Dimens.itemSpace,
            mainAxisSpacing: Dimens.itemSpace,
            itemCount: controller.poetryItems.length,
            itemBuilder: (context, index) {
              var item = controller.poetryItems[index];
              return ModuleUtils.bindPoetryItemByModel(
                  item, item.itemType,
                  title: MainController.typeName[item.type].name,
                  onTapFunction: () {
                controller.onTapPoetry(item);
              });
            },
          ),
        ));
  }

  /// search data
  _search(BuildContext context) {
    return TextField(
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
