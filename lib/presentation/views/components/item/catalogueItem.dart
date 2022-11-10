import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/model/catalogueModel.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../../../resource/style.dart';

class CatalogueItem extends StatelessWidget {
  const CatalogueItem( this.itemData,this.onTapFunction, {Key? key})
      : super(key: key);
  final CatalogueModel? itemData;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    var item = itemData;
    if (item == null) return Container();
    return GestureDetector(
        onTap: () {
          onTapFunction();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(
              Dimens.itemPaddingSpace,
              Dimens.itemPaddingSpace_4,
              Dimens.itemPaddingSpace,
              Dimens.itemPaddingSpace_4),
          decoration: BoxDecoration(
              color: item.selected ? AppColor.mainColor : AppColor.white,
              border:
              item.selected ? Border.all(color: AppColor.gray) : null,
              borderRadius: BorderRadius.circular(Dimens.itemRadius)),
          child: Text(
            item.text,
            style: item.selected
                ? Styles.textStyleWhite
                : Styles.textStyleGray,
            textAlign: TextAlign.center,
          ),
        )
    );
  }
}
