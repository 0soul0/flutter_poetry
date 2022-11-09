import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoetryPageController extends StatefulWidget {
  const PoetryPageController({required Key key}) : super(key: key);

  @override
  PoetryPageState createState() => PoetryPageState();
}

class PoetryPageState extends State<PoetryPageController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Column(children: [
        Container(
            padding: EdgeInsets.fromLTRB(
                Dimens.backgroundMarginLeft,
                Dimens.backgroundMarginTop,
                Dimens.backgroundMarginRight,
                Dimens.space),
            width: MediaQuery.of(context).size.width,
            child: _subTitle()),
        Divider(
            height: 0,
            thickness: Dimens.lineDividing,
            color: AppColor.dividerColor),
        Container(
            padding: EdgeInsets.fromLTRB(
                Dimens.backgroundMarginLeft,
                Dimens.textSpace,
                Dimens.backgroundMarginRight,
                Dimens.textSpace),
            height: 96,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.catalogue,
                      style: Styles.textStyleBlack,
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        AppLocalizations.of(context)!.seeMore,
                        style: Styles.helperStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimens.space,
                ),
                Expanded(child: _catalogueList()),
              ],
            )),
        Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
        Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimens.textSpace),
              child: _searchResult(),
            )),
        Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
        Container(
          height: 32,
          decoration: BoxDecoration(color: AppColor.dividerColor),
          child: _search(),
        ),
        Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
        // _search()
      ]),
    );
  }

  _subTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.menu_book,
          size: Dimens.iconSize,
        ),
        Container(
            margin: EdgeInsets.only(left: Dimens.textSpace),
            child: Text(
              AppLocalizations.of(context)!.poetry,
              style: Styles.subTitleStyleBlack,
              textAlign: TextAlign.center,
            ))
      ],
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
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(
              Dimens.itemPaddingSpace, 0, Dimens.itemPaddingSpace, 0),
          decoration: BoxDecoration(
              color: AppColor.white,
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(Dimens.itemRadius)),
          child: Text(
            "羨慕200-250",
            style: Styles.textStyleGray,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  _searchResult() {
    return AlignedGridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 1,
      crossAxisSpacing: Dimens.itemSpace,
      mainAxisSpacing: Dimens.itemSpace,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.fromLTRB(Dimens.itemSpace, 2, Dimens.itemSpace, 2),
          padding: EdgeInsets.all(Dimens.itemSpace),
          decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.gray,
                  blurRadius: 2,
                  offset: const Offset(0, 0), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(Dimens.itemRadius / 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "羨慕200-250",
                style: Styles.textStyleBlack,
              ),
              Text(
                "歌詞",
                style: Styles.helperStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  _search() {
    return TextField(
      textAlign: TextAlign.left,
      onChanged: (value) {},
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.backgroundColor,
          hintText: AppLocalizations.of(context)!.searchHelper,
          hintStyle: Styles.helperStyle,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: AppColor.dividerColor),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColor.secondColor),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.moduleRadius),
                  bottomRight: Radius.circular(Dimens.moduleRadius))
          ),
          contentPadding: EdgeInsets.all(Dimens.itemPaddingSpace_4),
          prefixIcon: const Icon(Icons.search)),
    );
  }
}
