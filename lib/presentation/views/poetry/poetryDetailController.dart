import 'dart:convert';
import 'dart:isolate';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_isolate/easy_isolate.dart' as isolate;
import 'package:easy_isolate/easy_isolate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poetry/presentation/views/base/baseController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_extend/share_extend.dart';

import '../../../domain/dao/poetryDao.dart';
import '../../../domain/fxDataBaseManager.dart';
import '../../../domain/model/poetryModel.dart';
import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../../../tool/is_check.dart';
import '../widget/text_unit_widget.dart';

/// A class represent controller of poetry
class PoetryDetailController extends BaseController<PoetryModel> {
  late PoetryDao _poetryDao;

  RxList<String> items = List<String>.from([]).obs;
  Rx<String> strItems = "".obs;
  Rx<String> refrain = "".obs;
  Rx<String> title = "".obs;
  RxList<SpectrumModel> spectrumAndMedia = List<SpectrumModel>.from([]).obs;
  RxList<SpectrumModel> media = List<SpectrumModel>.from([]).obs;
  RxList<SpectrumModel> spectrum = List<SpectrumModel>.from([]).obs;
  RxList<LanguageUrlModel> languageUrl = List<LanguageUrlModel>.from([]).obs;
  Rx<SpectrumModel> selectSpectrum = SpectrumModel().obs;
  Rx<Duration> duration = const Duration(seconds: 0).obs;
  RxBool loadFinish = false.obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  Rx<PlayerState> playState = PlayerState.stopped.obs;
  RxBool playerUIStatus = false.obs;
  RxDouble ddd = 0.0.obs;
  PageController pageController = PageController(initialPage: 0);
  double screenWidth = ScreenUtil.defaultSize.width;
  double times = 4 / 5;
  AudioPlayer selectPlayer = AudioPlayer();
  var lastSplitIndex = 0;
  final scrollController = ScrollController();
  final GlobalKey keyRefrain = GlobalKey();
  Rx<String> imagePath ="".obs;

  int fake = 0;

  @override
  onInit() async {
    super.onInit();
    await init();
    initState();
  }

  @override
  void onPaused() {
    selectPlayer.pause();
    super.onPaused();
  }

  @override
  void onClose() {
    super.onClose();
    for (var element in spectrumAndMedia) {
      element.play.release();
    }

    setVerticalScreen();
  }

  @override
  refresh() {
    initState();
  }

  initState() {
    title.value = arguments.getTitle();
    setPoetryItemToList(arguments);
    setRefrain(arguments);
    setHrefToOtherLanguageHymns(arguments);

    initMusicPlayer();
  }

  init() async {
    _poetryDao = await FxDataBaseManager.poetryDao();
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
    downloadMusic();
    //
    // final mainPort = ReceivePort();
    // await Isolate.spawn((mainSendPort) {
    //   final newPort = ReceivePort();
    //   mainSendPort.send(newPort.sendPort);
    //   newPort.listen((message) async {
    //     List<SpectrumModel> list = message;
    //     for (var i = 0; i < list.length; i++) {
    //       if (list[i].play.source == null && list[i].media.isNotEmpty) {
    //         await list[i].play.setSourceUrl(list[i].media);
    //       }
    //     }
    //     mainSendPort.send(1);
    //   });
    // }, mainPort.sendPort);
    //
    //
    // mainPort.listen((message) async{
    //   if (message is SendPort) {
    //     message.send(arguments.getMedia());
    //   } else {
    //
    //     // for (var i = 0; i < spectrumAndMedia.length; i++) {
    //     //   if (spectrumAndMedia[i].play.source == null && spectrumAndMedia[i].media.isNotEmpty) {
    //     //     await spectrumAndMedia[i].play.setSourceUrl(spectrumAndMedia[i].media);
    //     //   }
    //     // }
    //     spectrumAndMedia.value = message;
    //     if (media.isNotEmpty) {
    //       selectMusicPlayer(media[0].index);
    //     }
    //   }
    // });
  }

  downloadMusic() async {
    for (var i = 0; i < spectrumAndMedia.length; i++) {
      if (spectrumAndMedia[i].play.source == null &&
          spectrumAndMedia[i].media.isNotEmpty) {
        await spectrumAndMedia[i].play.setSourceUrl(spectrumAndMedia[i].media);
      }
    }
    if (media.isNotEmpty) {
      selectMusicPlayer(media[0].index);
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
      selectPlayer = spectrumAndMedia[sIndex].play;
      position.value = (await selectPlayer.getCurrentPosition()) ??
          const Duration(seconds: 0);
      duration.value =
          (await selectPlayer.getDuration()) ?? const Duration(seconds: 0);
      selectPlayer.onPositionChanged.listen((d) => position.value = d);
      selectPlayer.onDurationChanged.listen((d) => duration.value = d);
      selectPlayer.onPlayerStateChanged.listen((d) => playState.value = d);
      if (!loadFinish.value) {
        loadFinish.value = true;
      }
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
    refrain.value = splitContent(item.refrain);
  }

  /// set content of poetry to list
  ///
  /// @param item data of poetry
  setPoetryItemToList(PoetryModel item) {
    //分割段落
    // items.value = splitContent(item.content);
    strItems.value = splitContent(item.content);
  }

  // /// split content of poetry to list
  // ///
  // /// @param content data of poetry
  // /// @return String list of content
  // List<String> splitContent(String content) {
  //   List<String> strList = [];
  //   var contents = content.trim();
  //   var str = "";
  //   var lastSplitIndex = 0;
  //   for (int i = 0; i < contents.length; i++) {
  //     if (isNumeric(contents[i])) {
  //       if (str.isNotEmpty) {
  //         var arr = whichClearPivot(str, str.substring(lastSplitIndex));
  //         strList.add(arr[1]);
  //         str = arr[0];
  //       }
  //       strList.add(contents[i]);
  //       continue;
  //     }
  //
  //     str += contents[i];
  //
  //     if (isSymbols(contents[i])) {
  //       if (isMoreLong(str)) {
  //         var data = whichClearPivot(str, str.substring(0, lastSplitIndex));
  //         strList.add(data[1]);
  //         str = data[0];
  //       }
  //       lastSplitIndex = str.length;
  //     }
  //   }
  //   if (str.isNotEmpty) strList.add(str);
  //   return strList;
  // }

  String splitContent(String contents) {
    var strList = [];
    var str = "";
    var result ="";
    var paragraphWidth = stringWidth(contents)/((stringWidth(contents)/screenWidth).ceil());
    contents=contents.replaceAll("－", "");
    // 判斷分割點
    for (int i = 0; i < contents.length; i++) {
      if (isNumeric(contents[i]) || isSymbols(contents[i])) {
        strList.add(str+contents[i]);
        str = "";
        continue;
      }
      str += contents[i];
    }
    strList.add(str);
    // 判斷字段長度 超過螢幕跳行or 數字分段
    str="";
    for(int i=0;i<strList.length;i++){
      if(isNumeric(strList[i])){
        if(result.isEmpty){
          result = strList[i];
          str="";
          continue;
        }
        result += "\n$str\n${strList[i]}";
        str="";
        continue;
      }

      if(stringWidthLongThanScreen(str,strList[i],customWidth: paragraphWidth)&&str.isNotEmpty){
        result += "\n$str";
        str = strList[i];
        continue;
      }
      str+=strList[i];
    }
    result += "\n$str";
    return result;
  }

  stringWidthLongThanScreen(String str, String subStr,{double? customWidth}) {
    final text = str+subStr;
    final width = customWidth??screenWidth;
    return stringWidth(text) > width;
  }

  stringWidth(String str){
    final style = TextStyle(fontSize: Dimens.textSize*TextUnitWidget.textSizeTimes);
    final textWidth = IsCheck.measureText(str, style).width;
    return textWidth;
  }

  isMoreLong(String str) {
    var time = 1;
    if (RegExp("[a-zA-Z]+").hasMatch(str)) {
      time = 2;
    }

    double textWidth =
        str.length * Dimens.textSize * TextUnitWidget.textSizeTimes / time;
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
    final symbolsRegex = RegExp(r'^[,.，─：；;、。:？『』！“]+$');
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

  /// set href to other language hymns
  setHrefToOtherLanguageHymns(PoetryModel item) async {
    List<LanguageUrlModel> list = [];
    var maps = [];
    try {
      maps = json.decode(json.decode(item.languageUrl));
    } catch (error) {
      maps = json.decode(item.languageUrl);
    }
    for (var i = 0; i < maps.length; i++) {
      Map<String, dynamic> map = maps[i];
      for (var key in map.keys) {
        var poetryItem = await _poetryDao.queryByUrl("%${map[key]}");
        if (poetryItem.isNotEmpty) {
          list.add(LanguageUrlModel(poetryItem[0], language: key));
        }
      }
    }
    languageUrl.value = list;
  }

  shareImage(String imagePath) async {
    await ShareExtend.share(imagePath, "image");
  }

}
