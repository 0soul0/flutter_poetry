import 'package:flutter/material.dart';

import '../../../resource/style.dart';

class DateItem extends StatelessWidget {
  const DateItem({this.date = "", Key? key}) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        date,
        style: Styles.helperStyle,
      ),
    );
  }
}
