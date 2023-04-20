import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/search/search_controller.dart';
import 'package:flutter_poetry/presentation/views/widget/back_icon_button.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../widget/text_unit_widget.dart';
import 'list_page.dart';

class SearchAllFragment extends StatefulWidget {
  const SearchAllFragment({Key? key}) : super(key: key);

  @override
  State<SearchAllFragment> createState() => _SearchAllFragmentState();
}

class _SearchAllFragmentState extends State<SearchAllFragment>
    with WidgetsBindingObserver {
  final controller = Get.find<MySearchController>();

  @override
  void initState() {
    super.initState();
    if (controller.page.value == "search") {
      controller.poetrySearchItems.clear();
      controller.textController.text = "";
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height-MediaQueryData.fromView(View.of(context)).viewInsets.bottom,
        child:  Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: Dimens.bottomMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                      height: Dimens.toolbarHeight,
                      thickness: Dimens.moduleDividing,
                      color: Theme.of(context).colorScheme.background),
                  controller.page.value == "category"
                      ? TextUnitWidget(
                      controller.textController.text
                          .replaceAll("c://", ""),
                      style: Theme.of(context).textTheme.displayLarge)
                      : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
                  const Divider(
                      height: Dimens.moduleDividing,
                      thickness: Dimens.moduleDividing,
                      color: AppColor.dividerColor),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(
                            Dimens.backgroundMarginLeft,
                            0,
                            Dimens.backgroundMarginRight,
                            0),
                        child: ListPage("", ListType.search)),
                  ),
                  const Divider(
                      height: Dimens.moduleDividing,
                      thickness: Dimens.moduleDividing,
                      color: AppColor.dividerColor),
                  controller.page.value == "category"
                      ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                      : _search(context),
                  const Divider(
                      height: Dimens.moduleDividing,
                      thickness: Dimens.moduleDividing,
                      color: AppColor.dividerColor),
                ],
              ),
            ),
            const BackIconButton(
              opacity: 0.6,
            )
          ],
        )
      ),
    );
  }

  // ${MediaQueryData.fromView(View.of(context)).viewInsets.bottom}

  /// search data
  _search(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew =
        mqData.copyWith(textScaleFactor: TextUnitWidget.textSizeTimes);
    return SizedBox(
      height: 40 * TextUnitWidget.textSizeTimes,
      child: Stack(
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
                  fillColor: Theme.of(context).colorScheme.background,
                  hintText: "searchHelper".tr,
                  hintStyle: Theme.of(context).textTheme.displaySmall,
                  border: const OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 0, color: AppColor.dividerColor),
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
      ),
    );
  }
}


// Stack(
// children: [
// Container(
// margin: const EdgeInsets.only(bottom: Dimens.bottomMargin),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Divider(
// height: Dimens.toolbarHeight,
// thickness: Dimens.moduleDividing,
// color: Theme.of(context).colorScheme.background),
// controller.page.value == "category"
// ? TextUnitWidget(
// controller.textController.text
//     .replaceAll("c://", ""),
// style: Theme.of(context).textTheme.displayLarge)
// : const SizedBox(
// width: 0,
// height: 0,
// ),
// const Divider(
// height: Dimens.moduleDividing,
// thickness: Dimens.moduleDividing,
// color: AppColor.dividerColor),
// Expanded(
// child: Container(
// padding: const EdgeInsets.fromLTRB(
// Dimens.backgroundMarginLeft,
// 0,
// Dimens.backgroundMarginRight,
// 0),
// child: ListPage("", ListType.search)),
// ),
// const Divider(
// height: Dimens.moduleDividing,
// thickness: Dimens.moduleDividing,
// color: AppColor.dividerColor),
// controller.page.value == "category"
// ? const SizedBox(
// width: 0,
// height: 0,
// )
// : _search(context),
// const Divider(
// height: Dimens.moduleDividing,
// thickness: Dimens.moduleDividing,
// color: AppColor.dividerColor),
// ],
// ),
// ),
// const BackIconButton(
// opacity: 0.6,
// )
// ],
// )