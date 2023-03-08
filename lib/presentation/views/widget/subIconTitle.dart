import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/textUnitWidget.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';

class SubIconTitle extends StatelessWidget {
  SubIconTitle(this.text, this.icon,
      {this.style = Styles.subTitleStyleBlack, super.key});
  final String text;
  final IconData icon;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: Dimens.backgroundMarginLeft,
            top: Dimens.backgroundMarginTop,
            bottom: Dimens.backgroundMarginBottom),
        child: _subTitle());
  }

  _subTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: Dimens.iconSize,
        ),
        Container(
            margin: const EdgeInsets.only(left: Dimens.textSpace),
            child: TextUnitWidget(
              text,
              style: style,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
