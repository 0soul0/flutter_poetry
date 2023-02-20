import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:flutter_poetry/presentation/views/widget/scrollToHideWidget.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/style.dart';
import '../../../routes/appRoutes.dart';
import '../widget/backIconButton.dart';
import '../widget/textUnitWidget.dart';
import '../widget/touchUnitWidget.dart';

/// A class representing show detail of poetry
class PoetryDetail extends GetView<PoetryDetailController> {
  const PoetryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Divider(
                  color: Colors.grey,
                  height: 0.5,
                ),
                ScrollToHideWidget(
                  controller: controller.scrollController,
                  child: _refrain(),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 0.5,
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _slider(),
          Row(
            children: [
              TouchUnitWidget(
                onTapDelay: () {
                  Get.toNamed(AppRoutes.poetrySpectrum);
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimens.itemSpace * 1.7),
                  decoration: BoxDecoration(
                    color: AppColor.secondColor,
                    borderRadius: BorderRadius.circular(Dimens.itemSpace),
                  ),
                  child: const Icon(
                    Icons.queue_music_outlined,
                    color: AppColor.white,
                    size: Dimens.iconSize,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: Dimens.iconSize + Dimens.itemSpace * 3.4,
                  child: _changeTitle(),
                ),
              ),
              _play()
            ],
          )
        ],
      ),
    );
  }

  _changeTitle() {
    return Obx(() => PageView.builder(
          controller: controller.pageController,
          scrollDirection: Axis.vertical,
          itemCount: controller.spectrum.length,
          onPageChanged: (int page) {
            controller.selectMusicPlayer(page);
          },
          itemBuilder: (context, index) {
            var item = controller.spectrum[index];
            return Center(
              child: TextUnitWidget(
                "(${item.name})+${controller.arguments.title}",
                style: Styles.textStyleBlack,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ));
  }

  _play() {
    return Obx(() => Row(
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
        ));
  }

  _slider() {
    return Obx(() => Container(
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
        ));
  }

  _poetry() {
    return Obx(() => AlignedGridView.count(
          controller: controller.scrollController,
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
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
          child: Column(
            children: [
              const TextUnitWidget(
                "副歌",
                style: Styles.textStyleBlack,
              ),
              TextUnitWidget(controller.refrain.trim().toString(),
                  style: Styles.textStyleBlack, textAlign: TextAlign.left),
            ],
          ),
        ));
  }
}
