import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/itemModel.dart';
import 'package:flutter_poetry/presentation/views/item/searchResultItem.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../item/listMidItem.dart';
import '../../record/listPage.dart';
import '../../widget/backIconButton.dart';
import '../../widget/bannerWidget.dart';
import '../../widget/nativeBannerWidget.dart';
import '../../widget/textUnitWidget.dart';

class AboutFragment extends GetView<MineController> {
  const AboutFragment({Key? key}) : super(key: key);

  init(){
    controller.bindContactItem();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(Dimens.bannerHeight),
        child: BannerWidget(),
      ),
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
          itemCount: controller.contact.length,
          itemBuilder: (context, index) {
            ItemModel item = controller.contact[index];
            return ListMidItem(item.onTapFunction!,
                iconGif: item.iconGif,
                title: item.title,
                description: item.value);
          },
        ));
  }

}
