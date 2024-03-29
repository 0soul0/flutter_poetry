import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/widget/big_button_widget.dart';
import 'package:get/get.dart';

import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../widget/back_icon_button.dart';
import '../../widget/banner_widget.dart';
import '../../widget/small_button_widget.dart';
import '../../widget/text_unit_widget.dart';

class FontFragment extends GetView<MineController> {
  const FontFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(Dimens.bannerHeight),
        child: BannerWidget(),
      ),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
              Dimens.backgroundMarginLeft,
              Dimens.backgroundMarginTop,
              Dimens.backgroundMarginRight,
              Dimens.space),
          child: Column(children: [
            _textBox(context),
            const SizedBox(
              height: Dimens.space * 3,
            ),
            _seekbar(context),
            const SizedBox(
              height: Dimens.space * 3,
            ),
            _saveButton(context),
          ]),
        ),
        const BackIconButton(),
      ]),
    );
  }

  _textBox(BuildContext context) {
    return Obx(() => Container(
          width: MediaQuery.of(context).size.width,
          height: 450,
          padding: const EdgeInsets.symmetric(vertical: Dimens.itemSpace),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(Dimens.itemRadius)),
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  child: TextUnitWidget(
                    "textSizeSample".tr,
                    textScaleFactor: controller.valueToValueTime(
                        controller.seekValue.value.toDouble()),
                    style:  Theme.of(context).textTheme.displayMedium,
                  ))),
        ));
  }

  _seekbar(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.itemSpace),
        child: Column(
          children: [
            Row(
              children: [
                TextUnitWidget(
                  "textSize".tr,
                  style:  Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  width: Dimens.space,
                ),
                TextUnitWidget(
                  controller.seekValue.value.toString(),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.space,
            ),
            Slider(
              min: 8,
              max: 30,
              value: controller.seekValue.value.toDouble(),
              onChanged: (value) {
                controller.setSeekValue(value.toInt());
                controller.seekValueShow.value = true;
              },
            ),
          ],
        ),
      ),
    );
  }

  _saveButton(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.seekValueShow.value,
        child: BigButtonWidget(
          () {
            _showMyDialog(context);
            // Get.snackbar("saveSuccess".tr, "",
            //     duration: const Duration(milliseconds: 1200),
            //     snackPosition: SnackPosition.BOTTOM);
          },
        )));
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          title: const Icon(Icons.refresh,size: Dimens.iconSize*3,),
          content: TextUnitWidget(
            "restartAppText".tr,
            style:  Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            Center(
              child: SmallButtonWidget(
                'current'.tr,
                onPressed: () {
                  TextUnitWidget.textSizeTimes = controller
                      .valueToValueTime(controller.seekValue.value.toDouble());
                  controller.storage(
                      MineController.constSeekValue, TextUnitWidget.textSizeTimes);
                  //通知儲存
                  controller.items.firstWhere((element) => element.id == 1).value =
                      controller.seekValue.value.toString();
                  controller.seekValueShow.value = false;
                  Phoenix.rebirth(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

}
