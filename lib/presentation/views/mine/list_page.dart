import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUnit.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/model/itemModel.dart';
import '../../../resource/dimens.dart';
import '../widget/banner_widget.dart';

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
        _showImg(),
        Expanded(
          child: _mineList(),
        ),
      ]),
    );
  }

  _showImg() {
    return Obx(() => Center(
        child: TouchUnitWidget(
            onTapDelay: () {
              controller?.getImage();
            },
            child: CircleAvatar(
              backgroundColor: AppColor.gray,
              backgroundImage: controller!.imgFilePath.value.isNotEmpty?FileImage(File(controller!.imgFilePath.value)):null,
              radius: ScreenUtil.defaultSize.width / 7,
              child: controller!.imgFilePath.value.isNotEmpty
                  ? Container()
                  : const Icon(
                      Icons.camera_alt_outlined,
                      size: Dimens.iconSize,
                      color: AppColor.secondColor,
                    ),
            ))));
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
