import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:flutter_poetry/presentation/views/widget/banner_widget.dart';
import 'package:flutter_poetry/presentation/views/widget/scroll_to_hide_widget.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../resource/colors.dart';
import '../../../resource/style.dart';
import '../../../routes/app_routes.dart';
import '../widget/back_icon_button.dart';
import '../widget/select_table_widget.dart';
import '../widget/text_unit_widget.dart';
import '../widget/touch_unit_widget.dart';

/// A class representing show detail of poetry
class PoetryDetail extends GetView<PoetryDetailController> {
  const PoetryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle:true,
      //   backgroundColor:Colors.green,
      //   toolbarHeight: Dimens.toolbarHeight*3 * TextUnitWidget.textSizeTimes,
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   // backgroundColor: Colors.transparent,
      //   title: Container(
      //     color: Colors.amber,
      //     margin: EdgeInsets.zero,
      //     padding: EdgeInsets.zero,
      //     child: Container(
      //       margin: EdgeInsets.zero,
      //       padding: EdgeInsets.zero,
      //       child: Column(
      //         children: [
      //           const BannerWidget(),
      //           const SizedBox(height: Dimens.space,),
      //           title(),
      //           Center(
      //             child: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 _spectrum(() {
      //                   controller.selectPlayer.pause();
      //                   Get.toNamed(AppRoutes.poetrySpectrum);
      //                 }, Icons.queue_music_outlined, 'sheetMusic'.tr),
      //                 const SizedBox(
      //                   width: Dimens.itemSpace,
      //                 ),
      //                 _languageUrl()
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimens.toolbarHeight*3 * TextUnitWidget.textSizeTimes),
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const BannerWidget(),
                const SizedBox(height: Dimens.space,),
                title(),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _spectrum(() {
                        controller.selectPlayer.pause();
                        Get.toNamed(AppRoutes.poetrySpectrum);
                      }, Icons.queue_music_outlined, 'sheetMusic'.tr),
                      const SizedBox(
                        width: Dimens.itemSpace,
                      ),
                      _languageUrl()
                    ],
                  ),
                )
              ],
            ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.space * 2),
        margin: const EdgeInsets.only(bottom: Dimens.bottomMargin),
        child: _bottom(),
      ),
    );
  }

  _languageUrl() {
    return Obx(() => controller.languageUrl.isNotEmpty
        ? _featureItem(() {
            controller.selectPlayer.pause();
            controller.arguments = controller.languageUrl[0].item;
            controller.refresh();
          }, Icons.language, controller.languageUrl[0].language.tr)
        : const SizedBox(
            width: 0,
            height: 0,
          ));
    // return Obx(() => AlignedGridView.count(
    //       controller: controller.scrollController,
    //       scrollDirection: Axis.horizontal,
    //       crossAxisCount: 1,
    //       crossAxisSpacing: Dimens.itemSpace,
    //       mainAxisSpacing: Dimens.itemSpace,
    //       itemCount: controller.languageUrl.length,
    //       itemBuilder: (context, index) {
    //         var item = controller.languageUrl[index];
    //         return _buttonItem(() {}, Icons.language, item.language);
    //       },
    //     ));
  }

  _spectrum(Function onTap, IconData iconData, String text) {
    return Obx(() => controller.spectrum.isNotEmpty
        ? _featureItem(onTap, iconData, text)
        : Container());
  }

  _featureItem(Function onTap, IconData iconData, String text) {
    return Column(
      children: [
        TouchUnitWidget(
            onTapDelay: () {
              onTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.itemSpace / 2,
                  vertical: Dimens.itemSpace / 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.secondColor),
                borderRadius: BorderRadius.circular(Dimens.itemSpace),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconData,
                    color: AppColor.secondColor,
                    size: Dimens.iconSize * 1,
                  ),
                  TextUnitWidget(
                    text,
                    style: Styles.textStyleSecond,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  _bottom() {
    return Obx(() => controller.media.isNotEmpty
        ? controller.loadFinish.value
            ? Column(
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
              )
            : const LinearProgressIndicator()
        : SizedBox(
            height: 50,
            child: Center(
                child: TextUnitWidget(
              "noSheet".tr,
              style: Styles.textStyleGray,
            )),
          ));
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
    return Obx(() => TouchUnitWidget(
      onLongPress:(){
        HapticFeedback.vibrate();
      },
      child: SelectTableWidget(
            controller.strItems.value,
            style: Styles.textStyleBlack,
            textAlign: TextAlign.left,
          ),
    ));

    // return Obx(() => AlignedGridView.count(
    //       controller: controller.scrollController,
    //       scrollDirection: Axis.vertical,
    //       crossAxisCount: 1,
    //       itemCount: controller.items.length + 1,
    //       itemBuilder: (context, index) {
    //         if (index >= controller.items.length) {
    //           return const SizedBox(
    //             height: Dimens.itemSpace * 3,
    //           );
    //         }
    //         var item = controller.items[index];
    //         return SelectableText(
    //           item,
    //           style: Styles.textStyleBlack,
    //           textAlign: TextAlign.left,
    //         );
    //       },
    //     ));
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
              TouchUnitWidget(
                onLongPress:(){
                  HapticFeedback.vibrate();
                },
                child: SelectTableWidget(controller.refrain.trim().toString(),
                    style: Styles.textStyleBlack, textAlign: TextAlign.left),
              ),
              const Divider(
                color: Colors.grey,
                height: 0.5,
              ),
            ],
          ),
        ));
  }

  title() {
    return Obx(() => SelectTableWidget(controller.title.value,
        style: Styles.subTextStyleBlack, maxLines: 1
        // overflow: TextOverflow.ellipsis,
        ));
  }
}
