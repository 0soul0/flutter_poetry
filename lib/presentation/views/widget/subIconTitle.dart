import 'package:flutter/material.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';

class SubIconTitle extends StatelessWidget {
  const SubIconTitle(this.text,this.icon, {super.key});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left:Dimens.backgroundMarginLeft,
            top:Dimens.backgroundMarginTop,
            bottom:Dimens.backgroundMarginBottom),
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
            child: Text(
              text,
              style: Styles.subTitleStyleBlack,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
