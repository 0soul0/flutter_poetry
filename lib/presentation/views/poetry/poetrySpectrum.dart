import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:flutter_poetry/presentation/views/widget/back_icon_button.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../tool/is_check.dart';
import '../widget/banner_widget.dart';
import '../widget/float_fab_widget.dart';
import '../widget/image_unit_widget.dart';
import '../widget/text_unit_widget.dart';

class PoetrySpectrum extends StatefulWidget {
  const PoetrySpectrum({Key? key}) : super(key: key);

  @override
  State<PoetrySpectrum> createState() => _PoetrySpectrumState();
}

class _PoetrySpectrumState extends State<PoetrySpectrum>
    with SingleTickerProviderStateMixin {
  // 宣告 TabController
  late TabController tabController;
  late PoetryDetailController controller;

  @override
  void initState() {
    // 建立 TabController，vsync 接受的型態是 TickerProvider
    tabController = TabController(length: 3, vsync: this);
    controller = Get.find<PoetryDetailController>();
    // controller.setHorizontalScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.selectMusicPlayer(controller.spectrum[0].index);
    return IsCheck.isHorizontalScreen(context)
        ? Scaffold(
            body: Stack(
            children: [
              Row(
                children: [
                  SizedBox(width: 45, child: _spectrumTab()),
                  Expanded(
                      child: ListView(children: [
                    _getSpectrum(ScreenUtil.defaultSize.height)
                  ]))
                ],
              ),
              const BackIconButton(direction: directionHorizontal),
              // _play(),
            ],
          ))
        : Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(Dimens.bannerHeight),
              child: BannerWidget(),
            ),
            body: Stack(
              children: [
                Expanded(child: _getSpectrum(ScreenUtil.defaultSize.width)),
                const BackIconButton(),
              ],
            ),
            bottomNavigationBar: Container(
              height: Dimens.iconSize + Dimens.itemSpace,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.space),
              margin: const EdgeInsets.only(bottom: Dimens.bottomMargin),
              child: _bottom(),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    // controller.setVerticalScreen();
  }

  _bottom() {
    return Obx(() => DefaultTabController(
        length: controller.spectrum.length,
        child: TabBar(
          onTap: (index) {
            var item = controller.spectrum[index];
            controller.selectMusicPlayer(item.index);
            controller.spectrum.refresh();
          },
          unselectedLabelColor: AppColor.helperColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColor.secondColor,
            borderRadius: BorderRadius.circular(10),
          ),
          tabs: controller.spectrum.map((item) {
            return Tab(
              child: TextUnitWidget(
                item.name.tr,
              ),
            );
          }).toList(),
        )));
  }

  _spectrumTab() {
    return Obx(() => AlignedGridView.count(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 3,
        crossAxisSpacing: Dimens.itemSpace,
        mainAxisSpacing: Dimens.itemSpace,
        itemCount: controller.spectrum.length,
        itemBuilder: (context, index) {
          var item = controller.spectrum[index];
          return TouchUnitWidget(
            onTapDelay: () {
              controller.selectMusicPlayer(item.index);
              controller.spectrum.refresh();
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.space),
              height: ScreenUtil.defaultSize.height / 3,
              decoration: BoxDecoration(
                  color: controller.selectSpectrum.value.index == item.index
                      ? AppColor.mainColor
                      : AppColor.gray,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimens.moduleRadius),
                      bottomLeft: Radius.circular(Dimens.moduleRadius)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColor.mainColor,
                        blurRadius:
                            controller.selectSpectrum.value.index == item.index
                                ? 10
                                : 0,
                        offset: const Offset(0, 0))
                  ]),
              child: TextUnitWidget(
                item.nameV,
                textAlign: TextAlign.center,
                style: Styles.subTitleStyleWhite,
              ),
            ),
          );
        }));
  }

  _getSpectrum(width) {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ImageUnitWidget(
                controller.selectSpectrum.value.spectrum,
                width,
              ),
            ),
          ],
        ));
  }

  _play() {
    return Obx(() => controller.media.isNotEmpty
        ? Stack(
            children: [
              FloatFabWidget(
                Icons.music_note_outlined,
                const [
                  0,
                  Dimens.backIconPositionBottom / 4,
                  0,
                  Dimens.backgroundMarginRight * 2
                ],
                () {
                  controller.togglePlayerUI();
                },
                true,
                size: Dimens.iconSize * 1.2,
              ),
              FloatFabWidget(Icons.replay_10, const [
                0,
                Dimens.backIconPositionBottom / 4 + 42,
                0,
                Dimens.backgroundMarginRight * 2
              ], () {
                controller.seekMusic(-10 * 1000);
              }, controller.playerUIStatus.value),
              FloatFabWidget(
                  controller.playState.value == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  const [
                    0,
                    Dimens.backIconPositionBottom / 4 + 30,
                    0,
                    Dimens.backgroundMarginRight * 2 + 30
                  ], () {
                controller.toggleSMusicStatus();
              }, controller.playerUIStatus.value),
              FloatFabWidget(Icons.forward_10, const [
                0,
                Dimens.backIconPositionBottom / 4,
                0,
                Dimens.backgroundMarginRight * 2 + 42
              ], () {
                controller.seekMusic(10 * 1000);
              }, controller.playerUIStatus.value),
            ],
          )
        : Container());
  }
}
