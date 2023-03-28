import 'package:flutter/cupertino.dart';

class IsCheck {
  static bool isInteger(dynamic value) => value is int;

  static isHorizontalScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height;
  }
}
