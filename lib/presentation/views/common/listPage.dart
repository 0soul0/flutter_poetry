import 'package:flutter/material.dart';
import 'poetryPage.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  // List<Widget> getCatalogList() {
  //   List<Widget> list = [];
  //   for (int i = 0; i < 10; i++) {
  //     list.add(ListTile(
  //       title: Text(
  //         '詩歌200-300',
  //         style: Styles.textStyleWhite,
  //         textAlign: TextAlign.left,
  //         maxLines: 1,
  //       ),
  //       tileColor: AppColor.orange,
  //     ));
  //   }
  //   return list;
  // }

  // List<Widget> getItemList() {
  //   List<Widget> list = List.empty();
  //   for (int i = 0; i < 10; i++) {
  //     list.add(ListTile(
  //       title: Text(
  //         '304詩歌',
  //         style: Styles.textStyleBlack,
  //         textAlign: TextAlign.left,
  //         maxLines: 1,
  //       ),
  //       subtitle: Text(
  //         '詩歌內容描述詩歌內容描述詩歌內容描述歌內容描述歌內容描述',
  //         style: Styles.helperStyle,
  //         textAlign: TextAlign.left,
  //         overflow: TextOverflow.ellipsis,
  //         maxLines: 1,
  //       ),
  //     ));
  //   }
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        // curve: Curves.easeInBack,
        // loop: true,
        // transformer: new ThreeDTransformer(),
        itemCount: 2,
        itemBuilder: (context, index) {
          return const PoetryPageController(
            key: Key('search_poetry_1'),
          );
        },
      ),
    );
  }
}
