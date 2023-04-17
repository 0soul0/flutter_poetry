import 'package:flutter/material.dart';

import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../../../resource/style.dart';
import '../widget/text_unit_widget.dart';
import '../widget/touch_unit_widget.dart';

class ListMidItem extends StatelessWidget {
  const ListMidItem(this.onTapFunction,
      {this.iconGif = "",
      this.icon,
      this.text,
      this.title = "",
      this.description = "",
      Key? key})
      : super(key: key);
  final String title;
  final String description;
  final Function onTapFunction;
  final IconData? icon;
  final String iconGif;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return TouchUnitWidget(
      onTapDelay: () {
        onTapFunction();
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin:
            const EdgeInsets.fromLTRB(Dimens.itemSpace, 2, Dimens.itemSpace, 2),
        padding: const EdgeInsets.all(Dimens.itemSpace),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: const [
              BoxShadow(
                color: AppColor.gray,
                blurRadius: 2,
                offset: Offset(0, 0), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(Dimens.itemRadius / 2)),
        child: Row(
          children: [
            iconGif.isNotEmpty
                ? Image.asset(
                    iconGif,
                    height: Dimens.iconSize * 2,
                    width: Dimens.iconSize * 2,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            icon != null
                ? Icon(
                    icon,
                    weight: Dimens.iconSize,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            const SizedBox(
              width: Dimens.itemSpace,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUnitWidget(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  TextUnitWidget(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            text == null
                ? const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: Dimens.smallIconSize,
                    color: AppColor.gray,
                  )
                : text!.isNotEmpty
                    ? TouchUnitWidget(
                        onTapDelay: () {
                          onTapFunction();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimens.space / 1.5),
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.rectangle,
                              border: Border.all(color: AppColor.secondColor),
                              borderRadius:
                                  BorderRadius.circular(Dimens.itemRadius / 3)),
                          child: TextUnitWidget(
                            text!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.helperStyleSecond,
                          ),
                        ),
                      )
                    : Container()
          ],
        ),
      ),
    );
  }
}
