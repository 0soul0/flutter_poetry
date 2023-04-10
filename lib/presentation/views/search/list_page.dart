import 'package:flutter/material.dart';
import 'package:flutter_poetry/main_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../domain/model/poetryModel.dart';
import '../../../resource/dimens.dart';
import '../item/utils/moduleUnit.dart';
import 'search_controller.dart';

class ListPage extends StatelessWidget {
  ListPage(this.id, this.listType, {Key? key}) : super(key: key);

  // final double _fontSize = Dimens.helperSize * TextUnitWidget.textSizeTimes;
  late String id;
  late ListType listType;
  int page = 1;
  final MySearchController controller = Get.put(MySearchController());
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    if (listType == ListType.list) {
      controller.queryAllById(id);
    }
    return _result();
  }

  /// show search result
  _result() {
    return Obx(() => controller.loadingProgress.value.msg != "loading" &&
            (controller.poetryItemsMap[id] != null ||
                listType == ListType.search)
        ? SmartRefresher(
            controller: refreshController,
            enablePullDown: false,
            enablePullUp: true,
            header: const WaterDropHeader(),
            footer: const ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              completeDuration: Duration(milliseconds: 500),
            ),
            onLoading: () async {
              if (listType == ListType.list) {
                controller.queryAllById(id, page: page);
              } else {
                controller.search(controller.searchVal, page: page);
              }
              page++;
              refreshController.loadComplete();
            },
            child: AlignedGridView.count(
              controller: controller.scrollController,
              scrollDirection: Axis.vertical,
              crossAxisCount: 1,
              crossAxisSpacing: Dimens.itemSpace,
              mainAxisSpacing: Dimens.itemSpace,
              itemCount: listType == ListType.list
                  ? controller.poetryItemsMap[id].length
                  : controller.poetrySearchItems.length,
              itemBuilder: (context, index) {
                PoetryModel item = PoetryModel();
                int type = ModuleUtils.poetryModel;
                if (listType == ListType.list) {
                  item = controller.poetryItemsMap[id][index];
                } else {
                  item = controller.poetrySearchItems[index];
                  type = item.itemType;
                }
                var title = "";
                var files = MainController.allFiles
                    .where((element) => element.id == item.type.toString())
                    .toList();
                if (files.isNotEmpty) {
                  title = files[0].getName();
                }

                return ModuleUtils.bindPoetryItemByModel(item, type,
                    title: title, onTapFunction: () {
                  controller.onTapPoetry(item);
                });
              },
            ),
          )
        : Container());
  }
}

enum ListType {
  list,
  search,
}
