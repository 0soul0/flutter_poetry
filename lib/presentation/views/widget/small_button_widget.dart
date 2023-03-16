import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';

class SmallButtonWidget extends StatelessWidget {
  const SmallButtonWidget(this.text,{Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil.defaultSize.width,
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 72),
        decoration: const BoxDecoration(
            color: AppColor.secondColor,
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.moduleRadius))),
        child: Center(
          child: TextUnitWidget(
            text,
            style: Styles.helperStyleWhite,
          ),
        ));
  }
}
