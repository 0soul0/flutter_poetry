import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:flutter_poetry/presentation/views/widget/scrollToHideWidget.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/style.dart';
import '../../../routes/app_routes.dart';
import '../widget/backIconButton.dart';
import '../widget/textUnitWidget.dart';
import '../widget/touchUnitWidget.dart';

/// A class representing show detail of poetry
class PoetryDetail extends GetView<PoetryDetailController> {
  const PoetryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Dimens.toolbarHeight +
            Dimens.itemSpace * 3 * TextUnitWidget.textSizeTimes,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Column(
            children: [
              TextUnitWidget(
                controller.arguments.getTitle(),
                style: Styles.subTextStyleBlack,
                overflow: TextOverflow.ellipsis,
              ),
              _spectrum()
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: Dimens.textSpace * 2),
            child: Column(
              children: [
                Expanded(
                  child: _poetry(),
                ),
                ScrollToHideWidget(
                  controller: controller.scrollController,
                  child: _refrain(),
                ),
              ],
            ),
          ),
          const BackIconButton(
            tuneHeight: -Dimens.itemSpace * 9,
            opacity: 0.6,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.space * 2),
        child: _bottom(),
      ),
    );
  }

  _spectrum(){
    return  controller.spectrum.isNotEmpty
        ? Column(
      children: [
        TouchUnitWidget(
            onTapDelay: () {
              controller.selectPlayer.pause();
              Get.toNamed(AppRoutes.poetrySpectrum);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.itemSpace / 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.secondColor),
                borderRadius:
                BorderRadius.circular(Dimens.itemSpace),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.queue_music_outlined,
                    color: AppColor.secondColor,
                    size: Dimens.iconSize * 1,
                  ),
                  TextUnitWidget(
                    'sheetMusic'.tr,
                    style: Styles.helperStyleSecond,
                  ),
                ],
              ),
            )),
      ],
    )
        : Container();
  }

  _bottom(){
    return Obx(() =>
    controller.loadFinish.value?Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _slider(),
        Row(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: Dimens.iconSize + Dimens.itemSpace,
                  child: _changeSheet(),
                ),
              ),
            ),
            _play()
          ],
        )
      ],
    ):
    const LinearProgressIndicator()
    );
  }

  _changeSheet() {
    return Obx(() => DefaultTabController(
        length: controller.media.length,
        child: TabBar(
          onTap: (index) {
            controller.selectPlayer.pause();
            controller.selectMusicPlayer(controller.media[index].index);
          },
          unselectedLabelColor: AppColor.helperColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColor.secondColor,
            borderRadius: BorderRadius.circular(10),
          ),
          tabs: controller.media.map((item) {
            return Tab(
              child: TextUnitWidget(
                item.name.tr,
              ),
            );
          }).toList(),
        )));
  }

  _play() {
    return Obx(() => controller.media.isNotEmpty
        ? Row(
            children: [
              TouchUnitWidget(
                onTapDelay: () {
                  controller.seekMusic(-10 * 1000);
                },
                child: const Icon(
                  Icons.replay_10,
                  color: AppColor.black,
                  size: Dimens.iconSize * 1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.space),
                child: TouchUnitWidget(
                  onTapDelay: () {
                    controller.toggleSMusicStatus();
                  },
                  child: Icon(
                    controller.playState.value == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    color: AppColor.black,
                    size: Dimens.iconSize * 1.5,
                  ),
                ),
              ),
              TouchUnitWidget(
                onTapDelay: () {
                  controller.seekMusic(10 * 1000);
                },
                child: const Icon(
                  Icons.forward_10,
                  color: AppColor.black,
                  size: Dimens.iconSize * 1.5,
                ),
              ),
            ],
          )
        : Container());
  }

  _slider() {
    return Obx(() => controller.media.isNotEmpty
        ? Container(
            margin: const EdgeInsets.fromLTRB(Dimens.space, 0, Dimens.space, 0),
            child: Row(
              children: [
                TextUnitWidget(
                    "${controller.getDurationTime(controller.position.value)}"),
                Expanded(
                    child: SizedBox(
                  height: 20,
                  child: Slider(
                    thumbColor: AppColor.secondColor,
                    activeColor: AppColor.secondColor,
                    value: controller.getPosition(),
                    onChanged: (double value) {
                      controller.setPosition(value);
                    },
                  ),
                )),
                TextUnitWidget(
                    "${controller.getDurationTime(controller.duration.value)}"),
              ],
            ),
          )
        : Container());
  }

  _poetry() {
    return Obx(() => AlignedGridView.count(
          controller: controller.scrollController,
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          itemCount: controller.items.length + 1,
          itemBuilder: (context, index) {
            if (index >= controller.items.length) {
              return const SizedBox(
                height: Dimens.itemSpace * 3,
              );
            }

            var item = controller.items[index];
            return TextUnitWidget(
              item,
              style: Styles.textStyleBlack,
              textAlign: TextAlign.left,
            );
          },
        ));
  }

  _refrain() {
    if (controller.refrain.isEmpty) {
      return Container();
    }

    return Obx(() => Container(
          margin: const EdgeInsets.only(left: Dimens.textSpace * 1),
          padding: const EdgeInsets.symmetric(vertical: Dimens.itemSpace),
          child: Column(
            children: [
              const Divider(
                color: Colors.grey,
                height: 0.5,
              ),
              TextUnitWidget(
                "retain".tr,
                style: Styles.textStyleBlack,
              ),
              TextUnitWidget(controller.refrain.trim().toString(),
                  style: Styles.textStyleBlack, textAlign: TextAlign.left),
              const Divider(
                color: Colors.grey,
                height: 0.5,
              ),
            ],
          ),
        ));
  }
}
