import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:flutter_poetry/presentation/views/search/catalogueFull.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../domain/model/recordModel.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer';
import '../item/utils/moduleUnit.dart';
import '../widget/bannerWidget.dart';
import '../widget/emptyPageWidget.dart';
import '../widget/subIconTitle.dart';
import '../item/splitItem.dart';
import '../item/searchResultItem.dart';

class ListPage<T> extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);
  final RecordController controller = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Column(children: [
        const BannerWidget(),
        SubIconTitle("record".tr, Icons.receipt),
        const Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimens.itemSpace),
          child: _recordResult(),
        )),
        const Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
      ]),
    );
  }

  _recordResult() {
    var page = 1;
    return Obx(() => controller.recordItems.isNotEmpty
        ? SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: false,
            enablePullUp: true,
            header: const WaterDropHeader(),
            footer: const ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              completeDuration: Duration(milliseconds: 500),
            ),
            onLoading: () async {
              controller.loadData(page: page);
              page++;
              controller.refreshController.loadComplete();
            },
            child: AlignedGridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 1,
              crossAxisSpacing: Dimens.itemSpace,
              mainAxisSpacing: Dimens.itemSpace,
              itemCount: controller.recordItems.length,
              itemBuilder: (context, index) {
                var item = controller.recordItems[index];

                if (index >= controller.recordItemsType.length) {
                  if (index != 0 &&
                      controller.recordItems[index - 1].createTime
                              .split(" ")[0] ==
                          item.createTime.split(" ")[0]) {
                    controller.recordItemsType.add(ModuleUtils.poetryModel);
                  } else {
                    controller.recordItemsType
                        .add(ModuleUtils.poetryModelWithType);
                  }
                }

                return ModuleUtils.bindPoetryItemByModel(
                    item, controller.recordItemsType[index],
                    onTapFunction: () {
                  controller.onTapPoetry(item);
                }, title: item.createTime.split(" ")[0]);
              },
            ),
          )
        : const EmptyPageWidget());
  }
}
