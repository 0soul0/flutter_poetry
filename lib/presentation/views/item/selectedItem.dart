import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';

import '../../../domain/model/itemModel.dart';
import '../../../resource/style.dart';
import '../widget/text_unit_widget.dart';

class SelectedItem extends StatelessWidget {
  const SelectedItem(this.item, {this.onTapFunction, Key? key})
      : super(key: key);
  final Function? onTapFunction;
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    var color = item.selected ? AppColor.secondColor : AppColor.dividerColor;
    var textStyle =
        item.selected ? Styles.subTextStyleSecondColor : Styles.textStyleBlack;
    var lineWidth =
        item.selected ? Dimens.lineDividing * 4 : Dimens.lineDividing;
    return TouchUnitWidget(
      onTapDelay: () {
        if (onTapFunction == null) {
          item.onTapFunction!();
          return;
        }
        onTapFunction!();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimens.itemSpace * 2, horizontal: Dimens.itemSpace),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: lineWidth, color: color))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextUnitWidget(item.title, style: textStyle),
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
