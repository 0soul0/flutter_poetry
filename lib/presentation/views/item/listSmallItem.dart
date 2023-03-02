import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/touchUnitWidget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';

import '../../../resource/style.dart';
import '../widget/textUnitWidget.dart';

class ListSmallItem extends StatelessWidget {
  const ListSmallItem(this.onTapFunction,
      {this.title = "", this.value = "", Key? key})
      : super(key: key);

  final String title;
  final String value;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TouchUnitWidget(
        onTapDelay: () {
          onTapFunction();
        },
        child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimens.itemSpace * 2, horizontal: Dimens.itemSpace),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: Dimens.lineDividing,
                        color: AppColor.dividerColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextUnitWidget(title, style: Styles.textStyleBlack),
                Expanded(child: Container()),
                TextUnitWidget(value, style: Styles.textStyleBlack),
                const SizedBox(
                  width: Dimens.space,
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: Dimens.smallIconSize,
                  color: AppColor.gray,
                )
              ],
            )),
      ),
    );
  }
}
