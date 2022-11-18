import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';

import '../../../domain/model/item.dart';
import '../../../resource/style.dart';

class SelectedItem extends StatelessWidget {
  const SelectedItem(this.onTapFunction, this.item, {Key? key})
      : super(key: key);

  final Item item;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    var color = item.selected ? AppColor.secondColor : AppColor.dividerColor;
    var textStyle = item.selected ? Styles.subTextStyleSecondColor : Styles.textStyleBlack;
    var lineWidth = item.selected ? Dimens.lineDividing*4 : Dimens.lineDividing;
    return GestureDetector(
      onTap: () {
        onTapFunction();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimens.itemSpace * 2, horizontal: Dimens.itemSpace),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: lineWidth,
                      color: color))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(item.title, style: textStyle),
              Expanded(child: Container()),
              item.selected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      size: Dimens.iconSize,
                      color: AppColor.secondColor,
                    )
                  : Container()
            ],
          )),
    );
  }
}
