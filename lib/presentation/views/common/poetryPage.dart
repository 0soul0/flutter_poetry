import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../resource/dimens.dart';
import '../../../resource/style.dart';

class PoetryPageController extends StatefulWidget {
  const PoetryPageController({required Key key}) : super(key: key);

  @override
  PoetryPageState createState() => PoetryPageState();
}

class PoetryPageState extends State<PoetryPageController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.backgroundMarginLeft, Dimens.backgroundMarginTop, Dimens.backgroundMarginRight, 0),
      child: Column(children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: _subTitle()),
        // _catalogueState(),
        // _search()
      ]),
    );
  }

  _subTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.menu_book,size: Dimens.iconSize,),
        Container(
            margin: EdgeInsets.only(left: Dimens.textSpace),
            child: Text("詩歌",
              style: Styles.textStyleBlack,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }



  _catalogueState() {
    return Container(
      height: 80,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.helperColor),
                left: BorderSide(color: AppColor.helperColor),
                right: BorderSide(color: AppColor.helperColor),
                bottom: BorderSide(color: AppColor.helperColor),
              ),
              borderRadius: BorderRadius.circular(Dimens.stockRadius)),
          padding: EdgeInsets.fromLTRB(
              0,
              Dimens.itemPaddingSpace,
              0,
              Dimens.itemPaddingSpace),
          child: Expanded(child: _catalogueList())),
    );
  }

  _catalogueList() {
    return AlignedGridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 2,
      crossAxisSpacing: Dimens.itemSpace,
      mainAxisSpacing: Dimens.itemSpace,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(
              Dimens.itemPaddingSpace,
              Dimens.itemPaddingSpace_4,
              Dimens.itemPaddingSpace,
              Dimens.itemPaddingSpace_4),
          decoration: BoxDecoration(
              color: AppColor.mainColor,
              borderRadius: BorderRadius.circular(Dimens.itemRadius)),
          child: Text(
            "羨慕200-250",
            style: Styles.textStyleWhite,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  _search() {
    return Container(
      height: 32,
      child: TextField(
        textAlign: TextAlign.left,
        onChanged: (value) {},
        decoration: InputDecoration(
            labelText: "輸入詩歌編號/標題/內容/分類",
            labelStyle: Styles.helperStyle,
            contentPadding: EdgeInsets.all(Dimens.itemPaddingSpace_4),
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.stockRadius),
            )),
      ),
    );
  }
}
