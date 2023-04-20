import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../resource/colors.dart';
import '../../../resource/style.dart';

class BigButtonWidget extends StatelessWidget {
  const BigButtonWidget(this.onPressed,{this.title = "儲存", Key? key})
      : super(key: key);

  final String title;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return TouchUnitWidget(
      onTapDelay: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Container(
        width: ScreenUtil.defaultSize.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 36),
        decoration: const BoxDecoration(
            color: AppColor.secondColor,
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.moduleRadius))),
        child: Center(
          child: TextUnitWidget(
            title,
            style: Styles.subTextStyleWhite,
          ),
        ),
      ),
    );
  }
}
