import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_poetry/presentation/views/item/listDownloadItem.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../../domain/model/fileModel.dart';
import '../../../../domain/model/itemModel.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../widget/backIconButton.dart';
import '../../widget/bannerWidget.dart';

class PoetryListFragment extends GetView<MineController> {
  const PoetryListFragment({Key? key}) : super(key: key);

  init() {
    controller.bindHymn();
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
          itemCount: controller.hymn.length,
          itemBuilder: (context, index) {
            ItemModel item = controller.hymn[index];
            return ListDownloadItem(item.onTapFunction!,
                iconGif: item.iconGif,
                title: item.title,
                done: item.value == FileModel.keyUpdateDone.toString(),
                description: item.value == FileModel.keyUpdateDone.toString()
                    ? "downloadDone".tr
                    : "downloadUnDone".tr);
          },
        ));
  }
}
