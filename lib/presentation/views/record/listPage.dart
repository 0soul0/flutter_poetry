import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/catalogueModel.dart';
import 'package:flutter_poetry/presentation/views/record/recordController.dart';
import 'package:flutter_poetry/presentation/views/search/catalogueFull.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../domain/model/recordModel.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:developer';
import '../widget/subIconTitle.dart';
import '../item/splitItem.dart';
import '../item/searchResultItem.dart';

class ListPage<T> extends StatelessWidget {
  const ListPage({this.controller, Key? key}) : super(key: key);

  final RecordController? controller;

  init() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Column(children: [
        SubIconTitle(AppLocalizations.of(context)!.record, Icons.receipt),
        const Divider(
            height: 0,
            thickness: Dimens.lineDividing,
            color: AppColor.dividerColor),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimens.itemSpace),
          child: _searchResult(),
        )),
        // const Divider(
        //     height: Dimens.moduleDividing,
        //     thickness: Dimens.moduleDividing,
        //     color: AppColor.dividerColor),
        // Container(
        //   height: 32,
        //   decoration: const BoxDecoration(color: AppColor.dividerColor),
        //   child: _search(context),
        // ),
        const Divider(
            height: Dimens.moduleDividing,
            thickness: Dimens.moduleDividing,
            color: AppColor.dividerColor),
      ]),
    );
  }

  _searchResult() {
    return Obx(() => AlignedGridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          crossAxisSpacing: Dimens.itemSpace,
          mainAxisSpacing: Dimens.itemSpace,
          itemCount: controller?.recordItems.length,
          itemBuilder: (context, index) {
            var item = controller?.recordItems[index] ?? RecordModel(-1);
            if (false) {
              // return Column(
              //   children: [
              //     SplitItem(date: item.createTime),
              //     SearchResultItem(
              //       title: item.title,
              //       description: item.description,
              //     )
              //   ],
              // );
            } else {
              return SearchResultItem(
                (){},
                title: item.title,
                description: item.description,
              );
            }
          },
        ));
  }

// _search(BuildContext context) {
//   return TextField(
//     controller: controller?.textController,
//     textAlign: TextAlign.left,
//     onChanged: (value) {
//       controller?.search(value);
//     },
//     decoration: InputDecoration(
//         filled: true,
//         fillColor: AppColor.backgroundColor,
//         hintText: AppLocalizations.of(context)!.searchHelper,
//         hintStyle: Styles.helperStyle,
//         border: const OutlineInputBorder(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(Dimens.moduleRadius),
//                 bottomRight: Radius.circular(Dimens.moduleRadius))),
//         enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(width: 0, color: AppColor.dividerColor),
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(Dimens.moduleRadius),
//                 bottomRight: Radius.circular(Dimens.moduleRadius))),
//         focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(width: 1, color: AppColor.secondColor),
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(Dimens.moduleRadius),
//                 bottomRight: Radius.circular(Dimens.moduleRadius))),
//         contentPadding: EdgeInsets.all(Dimens.itemPaddingSpace_4),
//         prefixIcon: const Icon(Icons.search)),
//   );
// }
}
