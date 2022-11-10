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
        padding: EdgeInsets.fromLTRB(
            Dimens.backgroundMarginLeft,
            Dimens.backgroundMarginTop,
            Dimens.backgroundMarginRight,
            Dimens.space),
        width: MediaQuery.of(context).size.width,
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
            margin: EdgeInsets.only(left: Dimens.textSpace),
            child: Text(
              text,
              style: Styles.subTitleStyleBlack,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
