import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/itemModel.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../../resource/dimens.dart';
import '../../item/listMidItem.dart';
import '../../widget/back_icon_button.dart';
import '../../widget/banner_widget.dart';

class AboutFragment extends GetView<MineController> {
  const AboutFragment({Key? key}) : super(key: key);

  init() {
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
            color: Theme.of(context).colorScheme.background,
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
