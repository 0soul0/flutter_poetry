import 'package:flutter/widgets.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';

class Styles {
  static TextStyle textStyleWhite = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Dimens.textSize,
      color: AppColor.white);
  static TextStyle textStyleBlack = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Dimens.textSize,
      color: AppColor.textColor);
  static TextStyle helperStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Dimens.helperSize,
      color: AppColor.helperColor);

}
