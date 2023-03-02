import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUnit.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:flutter_poetry/presentation/views/search/catalogueFull.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../domain/model/itemModel.dart';
import '../../../domain/model/recordModel.dart';
import '../../../resource/dimens.dart';
import '../item/listSmallItem.dart';
import '../widget/bannerWidget.dart';

class ListPage<T> extends StatelessWidget {
  const ListPage({this.controller, Key? key}) : super(key: key);
  final MineController? controller;

  init() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.backgroundMarginRight),
      color: AppColor.backgroundColor,
      child: Column(children: [
        const BannerWidget(),
        Expanded(
          child: _mineList(),
        ),
      ]),
    );
  }

  _mineList() {
    return Obx(() => AlignedGridView.count(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          itemCount: controller?.items.length,
          itemBuilder: (context, index) {
            var item = controller?.items[index] ?? ItemModel();
            return ModuleUtils.bindMineItemByModule(item);
          },
        ));
  }
}
