import 'package:flutter/material.dart';
import '../common/listPage.dart';

class SearchFragment extends StatefulWidget {
  const SearchFragment({Key? key}) : super(key: key);

  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
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
          return const ListPage(
            key: Key('search_poetry_1'),
          );
        },
      ),
    );
  }
}
