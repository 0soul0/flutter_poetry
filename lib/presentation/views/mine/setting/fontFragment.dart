import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/widget/bigButton.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/model/itemModel.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../../../routes/singleton.dart';
import '../../item/selectedItem.dart';
import '../../widget/backIconButton.dart';
import '../../widget/textUnitWidget.dart';


class FontFragment extends GetView<MineController> {
  const FontFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextUnitWidget("banner"),
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
                      child: TextUnitWidget(
                        "主耶穌",
                        textScaleFactor: controller.valueToValueTime(
                            controller.seekValue.value.toDouble()),
                        style: Styles.textStyleBlack,
                      ))),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: TextUnitWidget(
                        "我如困鹿切慕溪水",
                        textScaleFactor: controller.valueToValueTime(
                            controller.seekValue.value.toDouble()),
                        style: Styles.textStyleBlack,
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
                const TextUnitWidget(
                  "字體大小",
                  style: Styles.textStyleBlack,
                ),
                const SizedBox(
                  width: Dimens.space,
                ),
                TextUnitWidget(
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
        child: BigButton(
          onPressed: () {
            TextUnitWidget.textSizeTimes = controller
                .valueToValueTime(controller.seekValue.value.toDouble());
            controller.storage(
                MineController.constSeekValue, TextUnitWidget.textSizeTimes);
            //通知儲存
            controller.items[1].value=controller.seekValue.value.toString();
            controller.seekValueShow.value = false;
            Phoenix.rebirth(context);
            Get.snackbar("儲存成功", "",
                duration: const Duration(milliseconds: 1200),
                snackPosition: SnackPosition.BOTTOM);
          },
        )));
  }
}
