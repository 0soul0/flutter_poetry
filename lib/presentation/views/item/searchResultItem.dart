import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../../../resource/style.dart';

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({this.title="",this.description="",Key? key}) : super(key: key);
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            title,
            style: Styles.textStyleBlack,
          ),
          Text(
            description,
            style: Styles.helperStyle,
          ),
        ],
      ),
    );
  }
}
