import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/model/itemModel.dart';
import '../../../../resource/colors.dart';
import '../../../../resource/dimens.dart';
import '../../item/selectedItem.dart';
import '../../widget/backIconButton.dart';


class LanguageFragment extends StatelessWidget {
  LanguageFragment({Key? key}) : super(key: key);

  late MineController controller;

  init() {
    controller = Get.find<MineController>();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: _list(),
            ),
          ],
        ),
        const BackIconButton()
      ]),
    );
  }

  // AlignedGridView.count(
  // scrollDirection: Axis.vertical,
  // crossAxisCount: 1,
  // itemCount: snapshot.length,
  // itemBuilder: (context, index) {
  // var item = snapshot[index];
  // return SelectedItem(() {
  // controller.storage(MineController.constLanguageSelected, item.id);
  // Get.back();
  // }, item);
  // },
  // );

  _list() {
    return FutureBuilder(
        future: getLanguages(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<ItemModel> list = snapshot.data;
              return AlignedGridView.count(
                scrollDirection: Axis.vertical,
                crossAxisCount: 1,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var item = list[index];
                  return SelectedItem(() {
                    controller.storage(
                        MineController.constLanguageSelected, item.id);
                    Get.back();
                  }, item);
                },
              );
            }
          } else {
            // 请求未结束，显示loading
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<ItemModel>> getLanguages() async {
    var list = [
      ItemModel(id: 0, title: "中文"),
      ItemModel(id: 1, title: "English"),
      ItemModel(id: 2, title: "French"),
    ];
    var index = await controller.read(MineController.constLanguageSelected);
    if (index != -1) {
      var item = list[index];
      item.selected = true;
      list[index] = item;
    }
    return list;
  }
}
