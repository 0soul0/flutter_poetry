import 'package:flutter/material.dart';

class SelectTableWidget extends SelectableText {
  static double textSizeTimes = 1;

  const SelectTableWidget(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
  });

  @override
  double? get textScaleFactor {
    if (super.textScaleFactor == null) return textSizeTimes;
    return super.textScaleFactor;
  }
}
