import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../resource/dimens.dart';
import '../item/utils/moduleUnit.dart';
import '../widget/banner_widget.dart';
import '../widget/empty_page_widget.dart';
import '../widget/subIconTitle.dart';

class ListPage<T> extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);
  final RecordController controller = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(children: [
        // const BannerWidget(),
        SubIconTitle("record".tr, Icons.receipt,style: Theme.of(context).textTheme.titleMedium,),
        const Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimens.itemSpace),
          child: _recordResult(),
        )),
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
                    item, controller.recordItemsType[index], onTapFunction: () {
                  controller.onTapPoetry(item);
                }, title: item.createTime.split(" ")[0]);
              },
            ),
          )
        : const EmptyPageWidget());
  }
}
