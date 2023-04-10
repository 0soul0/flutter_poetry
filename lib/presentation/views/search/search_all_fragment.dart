import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/presentation/views/widget/back_icon_button.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../../../routes/app_routes.dart';
import '../widget/banner_widget.dart';
import '../widget/text_unit_widget.dart';
import 'list_page.dart';

class SearchAllFragment extends GetView<MySearchController> {
  SearchAllFragment({Key? key}) : super(key: key);
  bool b = true;

  @override
  Widget build(BuildContext context) {
    if (b) {
      b = false;
      Future.delayed(Duration.zero,
          () => FocusScope.of(context).requestFocus(controller.commentFocus));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: Dimens.bottomMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BannerWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.itemSpace * 2),
                  child: Row(
                    children: [
                      TextUnitWidget(
                        'search'.tr,
                        style: Styles.subTitleStyleBlack,
                      ),
                      Expanded(child: Container()),
                      TouchUnitWidget(
                        onTapDelay: () {
                          Get.toNamed(AppRoutes.catalogueFull);
                        },
                        child: TextUnitWidget(
                          'catalogue'.tr,
                          style: Styles.subTitleStyleBlack,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: Dimens.iconSize - 4,
                      )
                    ],
                  ),
                ),
                const Divider(
                    height: Dimens.moduleDividing,
                    thickness: Dimens.moduleDividing,
                    color: AppColor.dividerColor),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(
                          Dimens.backgroundMarginLeft,
                          0,
                          Dimens.backgroundMarginRight,
                          0),
                      child: ListPage("", ListType.search)),
                ),
                const Divider(
                    height: Dimens.moduleDividing,
                    thickness: Dimens.moduleDividing,
                    color: AppColor.dividerColor),
                Container(
                  height: 32 * TextUnitWidget.textSizeTimes,
                  decoration: const BoxDecoration(color: AppColor.dividerColor),
                  child: _search(context),
                ),
                const Divider(
                    height: Dimens.moduleDividing,
                    thickness: Dimens.moduleDividing,
                    color: AppColor.dividerColor),
              ],
            ),
          ),
          const BackIconButton(
            opacity: 0.6,
          )
        ],
      ),
    );
  }

  /// search data
  _search(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew =
        mqData.copyWith(textScaleFactor: TextUnitWidget.textSizeTimes);
    return Stack(
      children: [
        TextUnitWidget(
          "searchHelper".tr,
          style: Styles.helperStyle16,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        MediaQuery(
          data: mqDataNew,
          child: TextField(
            controller: controller.textController,
            focusNode: controller.commentFocus,
            textAlign: TextAlign.left,
            onChanged: (value) {
              if (value.isEmpty) {
                value = "!!!!!!!!!!!!!!!!!";
              }
              controller.search(value);
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.backgroundColor,
                hintText: "searchHelper".tr,
                hintStyle: Styles.helperStyle16,
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
