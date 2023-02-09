import 'package:flutter/material.dart';

import '../../../resource/style.dart';
import '../widget/textUnitWidget.dart';

class SplitItem extends StatelessWidget {
  const SplitItem({this.name = "", Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextUnitWidget(
        name,
        style: Styles.helperStyle,
      ),
    );
  }
}
