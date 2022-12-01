import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/dimens.dart';

import '../../../resource/colors.dart';
import '../../../resource/style.dart';

class BigButton extends StatelessWidget {
  const BigButton({this.onPressed, this.title = "儲存", Key? key})
      : super(key: key);

  final String title;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.bigButtonMargin),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.secondColor),
        child: Text(
          title,
          style: Styles.textStyleWhite,
        ),
        onPressed: () {
          onPressed!();
        },
      ),
    );
  }
}
