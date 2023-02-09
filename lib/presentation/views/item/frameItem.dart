import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';

import '../../../resource/style.dart';
import '../widget/textUnitWidget.dart';

class FrameItem extends StatelessWidget {
  const FrameItem(this.onTapFunction,{this.title = "", this.value = "", Key? key})
      : super(key: key);

  final String title;
  final String value;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTapFunction();
      },
      child: Container(
          decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimens.moduleRadius)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.frameBackgroundColor_1,
                  AppColor.frameBackgroundColor_2,
                ],
              )),
          padding:
              const EdgeInsets.all(Dimens.itemSpace + Dimens.itemPaddingSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUnitWidget(title, style: Styles.subTitleStyleWhite),
              const SizedBox(
                height: Dimens.space,
              ),
              TextUnitWidget(value, style: Styles.textStyleGray),
            ],
          )),
    );
  }
}
