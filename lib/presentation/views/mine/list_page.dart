import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/item/utils/moduleUnit.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../domain/model/itemModel.dart';
import '../../../resource/dimens.dart';
import '../../../resource/themes.dart';
import '../widget/banner_widget.dart';
import '../widget/text_unit_widget.dart';

class ListPage<T> extends StatelessWidget {
  const ListPage({this.controller, Key? key}) : super(key: key);
  final MineController? controller;

  init() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.backgroundMarginRight),
      color: Theme.of(context).colorScheme.background,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _showImg(),
        Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.itemSpace, horizontal: Dimens.itemSpace),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: Dimens.lineDividing,
                        color: AppColor.dividerColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextUnitWidget("darkModel".tr,
                    style: Theme.of(context).textTheme.displayMedium),
                Expanded(child: Container()),
                Obx(() => Switch(
                    value: controller!.displayModel.value,
                    onChanged: (bool value) {
                      controller!.displayModel.value = value;
                      controller?.storage(MineController.constDarkModel, value);
                      if(value){
                        Get.changeTheme (Themes().darkTheme);
                      }else{
                        Get.changeTheme (Themes().lightTheme) ;
                      }
                    }))
              ],
            )),
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
              backgroundImage: controller!.imgFilePath.value.isNotEmpty
                  ? FileImage(File(controller!.imgFilePath.value))
                  : null,
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
