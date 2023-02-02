import 'package:flutter/material.dart';
import 'package:flutter_poetry/domain/model/poetryModel.dart';
import 'package:flutter_poetry/presentation/views/item/frameItem.dart';
import '../../../../domain/model/itemModel.dart';
import '../listSmallItem.dart';
import '../searchResultItem.dart';
import '../splitItem.dart';

class ModuleUtils {
  static const listSmallModule = 0;
  static const frameModule = 1;
  static const poetryModel = 0;
  static const poetryModelWithType = 1;

  static bindItemByModule(ItemModel item) {
    switch (item.module) {
      case listSmallModule:
        return ListSmallItem(
          item.onTapFunction ?? () {},
          title: item.title,
          value: item.value,
        );
      case frameModule:
        return FrameItem(
          item.onTapFunction ?? () {},
          title: item.title,
          value: item.value,
        );
    }
  }

  /// bind poetry item By Model for search page or history page
  ///
  /// @param item data of poetry
  /// @param type type of poetry item
  static bindPoetryItemByModel(PoetryModel item, int type,
      {Function? onTapFunction,title="詩歌"}) {
    switch (type) {
      case poetryModelWithType:
        return Column(
          children: [
            SplitItem(name: title),
            SearchResultItem(
              onTapFunction ?? () {},
              title: item.getTitle(),
              description: item.description,
            )
          ],
        );

      case poetryModel:
        return SearchResultItem(
          onTapFunction ?? () {},
          title: item.getTitle(),
          description: item.description,
        );
    }
  }
}
