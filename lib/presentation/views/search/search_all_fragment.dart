import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/presentation/views/widget/back_icon_button.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../../../routes/app_routes.dart';
import '../widget/banner_widget.dart';
import '../widget/text_unit_widget.dart';
import 'list_page.dart';

class SearchAllFragment extends GetView<MySearchController> {
  SearchAllFragment({Key? key}) : super(key: key);
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("SSSS"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_counter'),
            TextField(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
  final myController = TextEditingController();
  // @override
  // Widget build(BuildContext context) {
  //   if (controller.page.value == "search") {
  //     controller.poetrySearchItems.clear();
  //     controller.textController.text = "";
  //   }
  //   return Column(
  //     children: [
  //       Container(height: 300,),
  //       TextField(controller: myController,)
  //     ],
  //   );
  //
  //
  //   // return Scaffold(
  //   //   body: Stack(
  //   //     children: [
  //   //       Container(
  //   //         margin: const EdgeInsets.only(bottom: Dimens.bottomMargin),
  //   //         child: Column(
  //   //           mainAxisSize: MainAxisSize.min,
  //   //           children: [
  //   //             Divider(
  //   //                 height: Dimens.toolbarHeight,
  //   //                 thickness: Dimens.moduleDividing,
  //   //                 color: Theme.of(context).colorScheme.background),
  //   //             controller.page.value == "category"
  //   //                 ? TextUnitWidget(
  //   //                     controller.textController.text.replaceAll("c://", ""),
  //   //                     style: Theme.of(context).textTheme.displayLarge)
  //   //                 : const SizedBox(
  //   //                     width: 0,
  //   //                     height: 0,
  //   //                   ),
  //   //             const Divider(
  //   //                 height: Dimens.moduleDividing,
  //   //                 thickness: Dimens.moduleDividing,
  //   //                 color: AppColor.dividerColor),
  //   //             Expanded(
  //   //               child: Container(
  //   //                   padding: const EdgeInsets.fromLTRB(
  //   //                       Dimens.backgroundMarginLeft,
  //   //                       0,
  //   //                       Dimens.backgroundMarginRight,
  //   //                       0),
  //   //                   child: ListPage("", ListType.search)),
  //   //             ),
  //   //             const Divider(
  //   //                 height: Dimens.moduleDividing,
  //   //                 thickness: Dimens.moduleDividing,
  //   //                 color: AppColor.dividerColor),
  //   //             controller.page.value == "category"
  //   //                 ? const SizedBox(
  //   //               width: 0,
  //   //               height: 0,
  //   //             )
  //   //                 : _search(context),
  //   //             const Divider(
  //   //                 height: Dimens.moduleDividing,
  //   //                 thickness: Dimens.moduleDividing,
  //   //                 color: AppColor.dividerColor),
  //   //           ],
  //   //         ),
  //   //       ),
  //   //       const BackIconButton(
  //   //         opacity: 0.6,
  //   //       )
  //   //     ],
  //   //   ),
  //   // );
  // }

  /// search data
  _search(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew =
        mqData.copyWith(textScaleFactor: TextUnitWidget.textSizeTimes);
    return Stack(
      children: [
        TextUnitWidget(
          "searchHelper".tr,
          style: Styles.helperStyle16,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        MediaQuery(
          data: mqDataNew,
          child: TextField(
            autofocus: true,
            controller: controller.textController,
            focusNode: controller.commentFocus,
            textAlign: TextAlign.left,
            onChanged: (value) {
              if (value.isEmpty) {
                value = "!!!!!!!!!!!!!!!!!";
              }
              controller.search(value);
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.backgroundColor,
                hintText: "searchHelper".tr,
                hintStyle: Styles.helperStyle16,
                border: const OutlineInputBorder(
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(Dimens.moduleRadius),
                    //     bottomRight: Radius.circular(Dimens.moduleRadius))
                    ),
                enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 0, color: AppColor.dividerColor),
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(Dimens.moduleRadius),
                  //     bottomRight: Radius.circular(Dimens.moduleRadius))
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColor.secondColor),
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(Dimens.moduleRadius),
                  //     bottomRight: Radius.circular(Dimens.moduleRadius))
                ),
                contentPadding: const EdgeInsets.all(Dimens.itemPaddingSpace_4),
                prefixIcon: const Icon(Icons.search)),
          ),
        ),
      ],
    );
  }
}
