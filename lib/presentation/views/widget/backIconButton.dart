import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';

const int directionVertical=0;
const int directionHorizontal=1;

class BackIconButton extends StatelessWidget {
  const BackIconButton({Key? key,this.direction=directionVertical}) : super(key: key);

  final int direction; //手機螢幕方向

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: direction==directionVertical?Dimens.backIconPositionBottom:Dimens.backIconPositionBottom/4,
      left: direction==directionVertical?0:Dimens.backIconPositionRight,
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_circle_left_sharp,
              color: AppColor.mainColor, size: Dimens.backIconSize)),
    );
  }
}
