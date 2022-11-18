import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUntils.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:flutter_poetry/presentation/views/search/catalogueFull.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../domain/model/item.dart';
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
      color: AppColor.backgroundColor,
      child: Column(children: [
        const SizedBox(
          height: Dimens.space,
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.textSpace),
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
            var item = controller?.items[index] ?? Item();
            return ModuleUtils.bindItemByModule(item);
          },
        ));
  }
}
