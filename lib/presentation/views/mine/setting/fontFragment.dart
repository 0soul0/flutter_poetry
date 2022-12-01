import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/widget/bigButton.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/model/item.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../item/selectedItem.dart';
import '../../widget/backIconButton.dart';

class FontFragment extends StatelessWidget {
  FontFragment({Key? key}) : super(key: key);

  late MineController controller;

  init() {
    controller = Get.find<MineController>();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text("SSS"),
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
            _seekbar(),
            const SizedBox(
              height: Dimens.space * 3,
            ),
            _saveButton(),
          ]),
        ),
        const BackIconButton(),
      ]),
    );
  }

  _textBox(BuildContext context) {
    return Obx(() => Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.gray),
            borderRadius: BorderRadius.circular(Dimens.itemRadius)),
        child: Center(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "主耶穌",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: controller?.seekValue.value.toDouble(),
                            color: AppColor.textColor),
                      ))),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "我如困鹿切慕溪水",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: controller.seekValue.value.toDouble(),
                            color: AppColor.textColor),
                      ))),
            ],
          ),
        )));
  }

  _seekbar() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.itemSpace),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "字體大小",
                  style: Styles.textStyleBlack,
                ),
                const SizedBox(
                  width: Dimens.space,
                ),
                Text(
                  controller.seekValue.value.toString(),
                  style: Styles.textStyleBlack,
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.space,
            ),
            NeumorphicSlider(
              min: 8,
              max: 40,
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

  _saveButton() {
    return Obx(() => Visibility(
        visible: controller.seekValueShow.value,
        child: BigButton(
          onPressed: () {
            controller.storage(
                MineController.constSeekValue, controller.seekValue.value);
            controller.seekValueShow.value = false;
            Get.snackbar("儲存成功", "", snackPosition: SnackPosition.BOTTOM);
          },
        )));
  }
}
