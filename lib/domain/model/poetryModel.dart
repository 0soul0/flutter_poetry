import 'package:audioplayers/audioplayers.dart';
import 'package:floor/floor.dart';
import 'package:flutter_svg/svg.dart';

import '../../presentation/views/item/utils/moduleUnit.dart';

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
      this.description = ""});

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
    if (singMedia.isNotEmpty) {
      list.add(SpectrumModel(
          index: 0, name: "歌唱", media: singMedia, spectrum: "", nameV: "歌\n唱"));
    }
    if (guitarMedia.isNotEmpty || guitarSpectrum.isNotEmpty) {
      list.add(SpectrumModel(
          index: 1,
          name: "吉他",
          media: guitarMedia,
          spectrum: guitarSpectrum,
          nameV: "吉\n他"));
    }
    if (getPianoMedia().isNotEmpty || pianoSpectrum.isNotEmpty) {
      list.add(SpectrumModel(
          index: 2,
          name: "鋼琴",
          media: getPianoMedia(),
          spectrum: pianoSpectrum,
          nameV: "鋼\n琴"));
    }
    return list;
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
    };
  }

  PoetryModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? "";
    number = map["number"] ?? 0;
    type = map["type"] ?? 0;
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
