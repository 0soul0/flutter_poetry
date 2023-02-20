import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/touchUnitWidget.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';

const int directionVertical = 0;
const int directionHorizontal = 1;

class BackIconButton extends StatelessWidget {
  const BackIconButton(
      {Key? key,
      this.direction = directionVertical,
      this.tuneHeight = 0,
      this.opacity = 1})
      : super(key: key);

  final int direction; //手機螢幕方向
  final double tuneHeight;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: direction == directionVertical
          ? Dimens.backIconPositionBottom + tuneHeight
          : Dimens.backIconPositionBottom / 4 + tuneHeight,
      left: direction == directionVertical ? 0 : Dimens.backIconPositionRight,
      child: TouchUnitWidget(
          onTapDelay: () {
            Get.back();
          },
          child: Opacity(
            opacity: opacity,
            child: const Icon(Icons.arrow_circle_left_sharp,
                color: AppColor.mainColor, size: Dimens.backIconSize),
          )),
    );
  }
}
