import 'package:flutter/material.dart';
import 'package:flutter_poetry/main_controller.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../resource/dimens.dart';
import '../../../resource/style.dart';
import '../item/utils/moduleUnit.dart';
import '../widget/textUnitWidget.dart';
import 'search_controller.dart';

class ListPage extends StatelessWidget {
  ListPage(this.id,{Key? key}) : super(key: key);

  // final double _fontSize = Dimens.helperSize * TextUnitWidget.textSizeTimes;
  late String id;
  int page = 1;
  String searchVal = "";
  final SearchController controller = Get.put(SearchController());
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    controller.queryAllById(id);
    return _searchResult();
  }

  /// show search result
  _searchResult() {
    return Obx(() => controller.loadingProgress.value.msg != "loading"
        ?controller.poetryItemsMap.isNotEmpty?SmartRefresher(
            controller: refreshController,
            enablePullDown: false,
            enablePullUp: true,
            header: const WaterDropHeader(),
            footer: const ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              completeDuration: Duration(milliseconds: 500),
            ),
            onLoading: () async {
              controller.queryAllById(id, page: page);
              page++;
              refreshController.loadComplete();
            },
            child: AlignedGridView.count(
              controller: controller.scrollController,
              scrollDirection: Axis.vertical,
              crossAxisCount: 1,
              crossAxisSpacing: Dimens.itemSpace,
              mainAxisSpacing: Dimens.itemSpace,
              itemCount: controller.poetryItemsMap[id].length,
              itemBuilder: (context, index) {
                var item = controller.poetryItemsMap[id][index];
                var title = "";
                var files = MainController.allFiles
                    .where((element) => element.id == item.type.toString())
                    .toList();
                if (files.isNotEmpty) {
                  title = files[0].name.tr;
                }
                return ModuleUtils.bindPoetryItemByModel(
                    item, ModuleUtils.poetryModel, title: title,
                    onTapFunction: () {
                  controller.onTapPoetry(item);
                });
              },
            ),
          ):Container()
        : Center(
            child: SizedBox(
              height: Dimens.iconSize * 10,
              width: Dimens.iconSize * 10,
              child: Column(
                children: [
                  Image.asset(
                    "assets/icon_electric_guitar_music.gif",
                    height: Dimens.iconSize * 8,
                    width: Dimens.iconSize * 8,
                  ),
                  TextUnitWidget(
                    "${controller.loadingProgress.value.map?["number"]}/${controller.loadingProgress.value.map?["total"]}",
                    style: Styles.helperStyleBlack,
                  )
                ],
              ),
            ),
          ));
  }
}
