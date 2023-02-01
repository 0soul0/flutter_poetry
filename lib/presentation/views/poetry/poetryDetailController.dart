import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poetry/domain/model/fileModel.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:get/get.dart';

import '../../../domain/model/poetryModel.dart';

/// A class represent controller of poetry
class PoetryDetailController extends BaseController<PoetryModel> {
  RxList<String> items = List<String>.from([]).obs;
  Rx<String> refrain = "".obs;
  RxList<SpectrumModel> spectrum = List<SpectrumModel>.from([]).obs;
  Rx<SpectrumModel> selectSpectrum = SpectrumModel().obs;
  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  Rx<PlayerState> playState = PlayerState.stopped.obs;
  RxBool playerUIStatus = false.obs;
  RxDouble ddd = 0.0.obs;

  late List<AudioPlayer> players;
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
    selectMusicPlayer(0);
  }

  @override
  void onClose() {
    super.onClose();
    for (var element in players) {
      element.release();
    }

    setVerticalScreen();
  }



  /// toggle play status
  togglePlayerUI(){
    playerUIStatus.value=!playerUIStatus.value;
  }

  /// init music player
  initMusicPlayer() {
    spectrum.value = arguments.getMedia();
    selectSpectrum.value=spectrum.first;
    players = List.generate(spectrum.length,
        (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop));
  }

  /// select music which need to play
  ///
  /// @param position index of music
  selectMusicPlayer(int index) async {
    if (players[index].source == null) {
      players[index].setSourceUrl(spectrum[index].media);
    }
    selectPlayer = players[index];
    selectSpectrum.value= spectrum[index];
    selectPlayer.onDurationChanged.listen((d) => duration.value = d);
    selectPlayer.onPositionChanged.listen((d) => position.value = d);
    selectPlayer.onPlayerStateChanged.listen((d) => playState.value = d);
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
    var str = "";
    var contents = content.trim();
    for (int i = 0; i < contents.length; i++) {
      if (isNumeric(contents[i])) {
        if (str.isNotEmpty) strList.add(str);
        strList.add(contents[i]);
        continue;
      }

      if (isSymbols(contents[i]) && str.length >= 8) {
        strList.add(str + contents[i]);
        str = "";
        continue;
      }

      str += contents[i];
    }
    if (str.isNotEmpty) strList.add(str);
    return strList;
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
    final symbolsRegex = RegExp(r'^[,，：；;、。:！]+$');
    return symbolsRegex.hasMatch(str);
  }

  /// set horizontal of screen
  setHorizontalScreen(){
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  /// set Vertical of screen
  setVerticalScreen(){
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

}
