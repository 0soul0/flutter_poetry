import 'package:flutter/cupertino.dart';

class IsCheck {
  static bool isInteger(dynamic value) => value is int;

  static isHorizontalScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height;
  }

  static Size measureText(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size;
  }
}
