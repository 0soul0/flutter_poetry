import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../domain/model/poetryModel.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../widget/textUnitWidget.dart';

/// A class represent controller of poetry
class PoetryDetailController extends BaseController<PoetryModel> {
  RxList<String> items = List<String>.from([]).obs;
  Rx<String> refrain = "".obs;
  RxList<SpectrumModel> spectrumAndMedia = List<SpectrumModel>.from([]).obs;
  RxList<SpectrumModel> media = List<SpectrumModel>.from([]).obs;
  RxList<SpectrumModel> spectrum = List<SpectrumModel>.from([]).obs;
  Rx<SpectrumModel> selectSpectrum = SpectrumModel().obs;
  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  Rx<PlayerState> playState = PlayerState.stopped.obs;
  RxBool playerUIStatus = false.obs;
  RxDouble ddd = 0.0.obs;
  PageController pageController = PageController(initialPage: 0);
  double screenWidth = ScreenUtil.defaultSize.width;
  double times = 2 / 3;
  late AudioPlayer selectPlayer;

  final scrollController = ScrollController();
  final GlobalKey keyRefrain = GlobalKey();

  int fake = 0;

  @override
  onInit() {
    super.onInit();
    setPoetryItemToList(arguments);
    setRefrain(arguments);
    initMusicPlayer();
    if (media.isNotEmpty) {
      selectMusicPlayer(media[0].index);
    }
  }

  @override
  void onClose() {
    super.onClose();
    for (var element in spectrumAndMedia) {
      element.play.release();
    }

    setVerticalScreen();
  }

  /// toggle play status
  togglePlayerUI() {
    playerUIStatus.value = !playerUIStatus.value;
  }

  /// init music player
  initMusicPlayer() {
    spectrumAndMedia.value = arguments.getMedia();
    if (spectrumAndMedia.isNotEmpty) {
      media.value = spectrumAndMedia.where((p0) => p0.media != "").toList();
      spectrum.value =
          spectrumAndMedia.where((p0) => p0.spectrum != "").toList();
    }
  }

  /// select music which need to play
  ///
  /// @param position index of music
  selectMusicPlayer(int index) async {
    var sIndex = 0;
    for (var i = 0; i < spectrumAndMedia.length; i++) {
      if (spectrumAndMedia[i].index == index) {
        sIndex = i;
        break;
      }
    }
    if (spectrumAndMedia[sIndex].spectrum.isNotEmpty) {
      selectSpectrum.value = spectrumAndMedia[sIndex];
    }

    if (spectrumAndMedia[sIndex].media.isNotEmpty) {
      if (spectrumAndMedia[sIndex].play.source == null) {
        spectrumAndMedia[sIndex]
            .play
            .setSourceUrl(spectrumAndMedia[sIndex].media);
      }
      selectPlayer = spectrumAndMedia[sIndex].play;
      selectPlayer.onPositionChanged.listen((d) => position.value = d);
      selectPlayer.onDurationChanged.listen((d) => duration.value = d);
      selectPlayer.onPlayerStateChanged.listen((d) => playState.value = d);
    }
  }

  /// set position of sliver
  setPosition(double value) {
    int sec = ((value - getPosition()) * duration.value.inMilliseconds).round();
    seekMusic(sec);
  }

  /// get position of sliver
  ///
  /// @return position
  getPosition() {
    if (duration.value.inMilliseconds == 0) return 0.0;
    return position.value.inMilliseconds / (duration.value.inMilliseconds);
  }

  /// play music
  toggleSMusicStatus() async {
    if (selectPlayer.state == PlayerState.paused ||
        selectPlayer.state == PlayerState.stopped) {
      await selectPlayer.resume();
      return;
    }
    await selectPlayer.pause();
  }

  /// forward or replay music
  ///
  /// ＠param milliSeconds time
  seekMusic(int milliSeconds) async {
    int time = position.value.inMilliseconds;
    time += milliSeconds;
    await selectPlayer.seek(Duration(milliseconds: time));
  }

  /// get duration of time
  ///
  /// @param duration time
  getDurationTime(Duration duration) {
    int min = duration.inMinutes;
    int sec = duration.inSeconds % 60;
    return "${smallThenTenSuppleZero(min)}:${smallThenTenSuppleZero(sec)}";
  }

  /// small then Ten supple zero
  ///
  /// @param time time
  smallThenTenSuppleZero(int time) {
    if (time >= 10) return "$time";
    return "0$time";
  }

  /// set refrain of poetry
  ///
  /// @param item data of poetry
  setRefrain(PoetryModel item) {
    var refrainItem = "";
    splitContent(item.refrain).forEach((element) {
      refrainItem += "$element\n";
    });
    refrain.value = refrainItem;
  }

  /// set content of poetry to list
  ///
  /// @param item data of poetry
  setPoetryItemToList(PoetryModel item) {
    //分割段落
    items.value = splitContent(item.content);
  }

  /// split content of poetry to list
  ///
  /// @param content data of poetry
  /// @return String list of content
  List<String> splitContent(String content) {
    List<String> strList = [];
    var contents = content.trim();
    var str = "";
    var lastSplitIndex = 0;
    for (int i = 0; i < contents.length; i++) {
      if (isNumeric(contents[i])) {
        if (str.isNotEmpty) {
          var arr = whichClearPivot(str, str.substring(lastSplitIndex));
          strList.add(arr[1]);
          str = arr[0];
        }
        strList.add(contents[i]);
        continue;
      }

      str += contents[i];

      if (isSymbols(contents[i])) {
        if (isMoreLong(str)) {
          var data = whichClearPivot(str, str.substring(0, lastSplitIndex));
          strList.add(data[1]);
          str = data[0];
        }
        lastSplitIndex = str.length;
      }
    }
    if (str.isNotEmpty) strList.add(str);
    return strList;
  }

  whichClearPivot(String str1, String str2) {
    double len = str1.length * Dimens.textSize * TextUnitWidget.textSizeTimes;
    if (len >= screenWidth) return [str1.replaceAll(str2, ""), str2];
    double textWidth1 = (len - screenWidth * times).abs();
    double textWidth2 =
        (str2.length * Dimens.textSize * TextUnitWidget.textSizeTimes -
                screenWidth * times)
            .abs();
    if (textWidth1 > textWidth2) {
      return [str1.replaceAll(str2, ""), str2];
    }
    return ["", str1];
  }

  isMoreLong(String str) {
    double textWidth =
        str.length * Dimens.textSize * TextUnitWidget.textSizeTimes;
    return textWidth > screenWidth * times;
  }

  /// Is String is number
  ///
  /// @param str String
  /// @return Is number
  isNumeric(String str) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    return numericRegex.hasMatch(str);
  }

  /// Is String is symbols
  ///
  /// @param str String
  /// @return Is symbols
  isSymbols(String str) {
    final symbolsRegex = RegExp(r'^[,，─：；;、。:？『』！]+$');
    return symbolsRegex.hasMatch(str);
  }

  /// set horizontal of screen
  setHorizontalScreen() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  /// set Vertical of screen
  setVerticalScreen() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}
