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

class ListPage<T> extends StatelessWidget {
  const ListPage({this.controller, Key? key}) : super(key: key);
  final MineController? controller;

  init() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          Dimens.backgroundMarginLeft,
          Dimens.backgroundMarginTop,
          Dimens.backgroundMarginRight,
          Dimens.space),
      color: AppColor.backgroundColor,
      child: Column(children: [
        Expanded(
            child: Container(
          child: _mineList(),
        )),
      ]),
    );
  }

  _mineList() {
    return Obx(() => AlignedGridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          itemCount: controller?.items.length,
          itemBuilder: (context, index) {
            var item = controller?.items[index] ?? ItemModel();

            return ModuleUtils.bindMineItemByModule(item);
          },
        ));
  }
}
