import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:floor/floor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../data/route_api.dart';
import '../../presentation/views/item/utils/moduleUnit.dart';
import '../../tool/is_check.dart';

@entity
class PoetryModel {
  PoetryModel(
      {this.id = "",
      this.number = -1,
      this.type = 0,
      this.title = "",
      this.content = "",
      this.refrain = "",
      this.author = "",
      this.category = "",
      this.subCategory = "",
      this.url = "",
      this.pianoSpectrum = "",
      this.guitarSpectrum = "",
      this.pianoMedia = "",
      this.pianoMedia2 = "",
      this.singMedia = "",
      this.guitarMedia = "",
      this.description = "",
      this.languageUrl = "",
      this.notationSpectrum = ""});

  @primaryKey
  late String id;
  late int number;
  late int type; //0詩歌 1補充本
  late String title;
  late String content; //歌詞
  late String refrain; //副歌
  late String author;
  late String category;
  late String subCategory;
  late String url;
  late String pianoSpectrum;
  late String guitarSpectrum;
  late String pianoMedia;
  late String pianoMedia2;
  late String singMedia;
  late String guitarMedia;
  late String languageUrl; // new column
  late String notationSpectrum; // column

  /// locate used
  String description = ""; //搜尋結果的歌詞描述

  @ignore
  int itemType = ModuleUtils.poetryModel;

  getTitle() {
    return "$number $title";
  }

  getPianoMedia() {
    if (pianoMedia.isEmpty) {
      return pianoMedia2;
    }
    return pianoMedia;
  }

  getMedia() {
    List<SpectrumModel> list = [];

    // 過濾svg
    removeSvg();

    if (singMedia.isNotEmpty) {
      list.add(SpectrumModel(
          index: 0,
          name: "sing".tr,
          media: singMedia,
          spectrum: "",
          nameV: "singV".tr));
    }
    if (guitarMedia.isNotEmpty || guitarSpectrum.isNotEmpty) {
      list.add(SpectrumModel(
          index: 1,
          name: "guitar".tr,
          media: guitarMedia,
          spectrum: guitarSpectrum,
          nameV: "guitarV".tr));
    }
    if (getPianoMedia().isNotEmpty || pianoSpectrum.isNotEmpty) {
      list.add(SpectrumModel(
          index: 2,
          name: "piano".tr,
          media: getPianoMedia(),
          spectrum: pianoSpectrum,
          nameV: "sheetV".tr));
    }
    if (notationSpectrum.isNotEmpty) {
      list.add(SpectrumModel(
          index: 3,
          name: "notation".tr,
          media: "",
          spectrum: RouteApi.imgUrl + notationSpectrum,
          nameV: "sheetV".tr));
    }

    return list;
  }

  removeSvg() {
    if (guitarSpectrum.contains(".svg")) {
      guitarSpectrum = "";
    }

    if (notationSpectrum.contains(".svg")) {
      notationSpectrum = "";
    }

    if (pianoSpectrum.contains(".svg")) {
      pianoSpectrum = "";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'type': type,
      'title': title,
      'content': content,
      'refrain': refrain,
      'author': author,
      'category': category,
      'subCategory': subCategory,
      'url': url,
      'pianoSpectrum': pianoSpectrum,
      'guitarSpectrum': guitarSpectrum,
      'pianoMedia': pianoMedia,
      'pianoMedia2': pianoMedia2,
      'singMedia': singMedia,
      'description': description,
      'languageUrl': languageUrl,
      'notationSpectrum': notationSpectrum
    };
  }

  PoetryModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? "";

    if (map["number"] != null) {
      var cNumber = map["number"];
      if (!IsCheck.isInteger(map["number"])) {
        cNumber = int.parse(map["number"]);
      }
      number = cNumber;
    } else {
      number = 0;
    }

    var cType = map["type"];
    if (!IsCheck.isInteger(map["type"])) {
      cType = int.parse(map["type"]);
    }
    type = cType;
    title = map["title"] ?? "";
    content = map["content"] ?? "";
    refrain = map["refrain"] ?? "";
    author = map["author"] ?? "";
    category = map["category"] ?? "";
    subCategory = map["subCategory"] ?? "";
    url = map["url"] ?? "";
    pianoSpectrum = map["pianoSpectrum"] ?? "";
    guitarSpectrum = map["guitarSpectrum"] ?? "";
    pianoMedia = map["pianoMedia"] ?? "";
    pianoMedia2 = map["pianoMedia2"] ?? "";
    singMedia = map["singMedia"] ?? "";
    guitarMedia = map["guitarMedia"] ?? "";
    description = map["description"] ?? "";
    // List<LanguageUrlModel> list=[];
    // for(var item in map["languageUrl"]){
    //   list.add(LanguageUrlModel(language: item[0],url:item[1]));
    // }
    notationSpectrum = map["notationSpectrum"] ?? "";
    languageUrl = json.encode(map["languageUrl"]);
  }
}

class SpectrumModel {
  SpectrumModel(
      {this.index = 0,
      this.spectrum = "",
      this.media = "",
      this.name = "",
      this.nameV = "",
      this.pic});

  late int index;
  late String spectrum;
  late String media;
  late String name;
  late String nameV;
  AudioPlayer play = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  SvgPicture? pic; //垂直顯示
}

class LanguageUrlModel {
  LanguageUrlModel(
    this.item, {
    this.language = "",
  });

  late String language;
  PoetryModel item;
}
