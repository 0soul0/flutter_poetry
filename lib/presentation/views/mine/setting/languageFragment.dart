import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../../domain/model/itemModel.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../item/selectedItem.dart';
import '../../widget/backIconButton.dart';

class LanguageFragment extends GetView<MineController> {
  const LanguageFragment({Key? key}) : super(key: key);

  init(BuildContext context) {
    controller.bindLanguages(context);
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
                Dimens.backgroundMarginLeft,
                Dimens.backgroundMarginTop,
                Dimens.backgroundMarginRight,
                Dimens.space),
            color: AppColor.backgroundColor,
            child: Column(children: [
              Expanded(child: Container(child: _list())),
            ]),
          ),
          const BackIconButton(),
        ],
      ),
    );
  }

  _list() {
    return Obx(() => AlignedGridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          mainAxisSpacing: Dimens.space,
          itemCount: controller.language.length,
          itemBuilder: (context, index) {
            ItemModel item = controller.language[index];
            return SelectedItem(item);
          },
        ));
  }

  // AlignedGridView.count(
  // scrollDirection: Axis.vertical,
  // crossAxisCount: 1,
  // itemCount: snapshot.length,
  // itemBuilder: (context, index) {
  // var item = snapshot[index];
  // return SelectedItem(() {
  // controller.storage(MineController.constLanguageSelected, item.id);
  // Get.back();
  // }, item);
  // },
  // );
}
