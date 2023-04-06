import 'package:flutter/widgets.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';

class Styles {
  static const FontWeight fontTextWeight = FontWeight.w500;
  static const FontWeight fontHelperWeight = FontWeight.w400;
  static const FontWeight fontSubTextWeight = FontWeight.w500;

  static const TextStyle textStyleWhite = TextStyle(
      fontWeight: fontTextWeight,
      fontSize: Dimens.textSize,
      color: AppColor.white);

  static const TextStyle textStyleBlack = TextStyle(
      fontWeight: fontTextWeight,
      fontSize: Dimens.textSize,
      color: AppColor.textColor);

  static const TextStyle helperStyleSecond = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Dimens.helperSize,
      color: AppColor.secondColor);

  static const TextStyle textStyleSecond = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Dimens.textSize,
      color: AppColor.secondColor);

  static const TextStyle tabStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Dimens.textSize,
      color: AppColor.mainColor);

  static const TextStyle subTextStyleBlack = TextStyle(
      fontWeight: fontSubTextWeight,
      fontSize: Dimens.subTitleSize,
      color: AppColor.textColor);

  static const TextStyle subTextStyleWhite = TextStyle(
      fontWeight: fontSubTextWeight,
      fontSize: Dimens.subTitleSize,
      color: AppColor.white);

  static const TextStyle subTextStyleSecondColor = TextStyle(
      fontWeight: fontSubTextWeight,
      fontSize: Dimens.subTitleSize,
      color: AppColor.secondColor);

  static const TextStyle textStyleGray = TextStyle(
      fontWeight: fontTextWeight,
      fontSize: Dimens.textSize,
      color: AppColor.gray);

  static const TextStyle subTitleStyleBlack = TextStyle(
      fontWeight: fontSubTextWeight,
      fontSize: Dimens.subTitleSize,
      color: AppColor.textColor);

  static const TextStyle subTitleStyleWhite = TextStyle(
      fontWeight: fontSubTextWeight,
      fontSize: Dimens.subTitleSize,
      color: AppColor.white);

  static const TextStyle helperStyle = TextStyle(
      fontWeight: fontHelperWeight,
      fontSize: Dimens.helperSize,
      color: AppColor.helperColor);

  static const TextStyle helperStyleWhite = TextStyle(
      fontWeight: fontHelperWeight,
      fontSize: Dimens.helperSize,
      color: AppColor.white);

  static const TextStyle helperStyleBlack = TextStyle(
      fontWeight: fontHelperWeight,
      fontSize: Dimens.helperSize,
      color: AppColor.textColor);

  static const TextStyle subTitleStyleMainColor = TextStyle(
      fontWeight: fontSubTextWeight,
      fontSize: Dimens.textSize,
      color: AppColor.mainColor);

  static const TextStyle homeTextStyleSelected = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: Dimens.homeSize,
      color: AppColor.mainColor);

  static const TextStyle homeTextStyleUnSelect = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: Dimens.homeSize,
      color: AppColor.gray);
}
