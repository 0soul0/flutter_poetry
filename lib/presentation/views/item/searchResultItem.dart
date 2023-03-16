import 'package:flutter/material.dart';

import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../../../resource/style.dart';
import '../widget/text_unit_widget.dart';

class SearchResultItem extends StatelessWidget {
  const SearchResultItem(this.onTapFunction,
      {this.title = "", this.description = "", Key? key})
      : super(key: key);
  final String title;
  final String description;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin:
            const EdgeInsets.fromLTRB(Dimens.itemSpace, 2, Dimens.itemSpace, 2),
        padding: const EdgeInsets.all(Dimens.itemSpace),
        decoration: BoxDecoration(
            color: AppColor.white,
            boxShadow: const [
              BoxShadow(
                color: AppColor.gray,
                blurRadius: 2,
                offset: Offset(0, 0), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(Dimens.itemRadius / 2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextUnitWidget(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.textStyleBlack,
            ),
            TextUnitWidget(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.helperStyle,
            ),
          ],
        ),
      ),
    );
  }
}
