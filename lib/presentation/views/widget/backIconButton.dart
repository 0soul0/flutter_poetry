import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Dimens.backIconPositionBottom,
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_circle_left_sharp,
              color: AppColor.mainColor, size: Dimens.backIconSize)),
    );
  }
}
