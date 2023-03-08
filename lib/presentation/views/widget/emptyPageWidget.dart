import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/textUnitWidget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil.defaultSize.height / 3),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/logo_no_background.png",
              width: ScreenUtil.defaultSize.width / 3,
              height: ScreenUtil.defaultSize.width / 3,
              color: AppColor.helperColor,
            ),
            const TextUnitWidget("無數據", style: Styles.textStyleGray)
          ],
        ),
      ),
    );
  }
}
