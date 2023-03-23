import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';

class SmallButtonWidget extends StatelessWidget {
  const SmallButtonWidget(this.text,{this.onPressed,Key? key}) : super(key: key);

  final String text;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return TouchUnitWidget(
      onTapDelay: () {
        if(onPressed!=null){
          onPressed!();
        }
      },
      child: Container(
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
          )),
    );
  }
}
