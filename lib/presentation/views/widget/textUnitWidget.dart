import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/dimens.dart';

class TextUnitWidget extends Text {
  static double textSizeTimes = 1;

  const TextUnitWidget(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  @override
  double? get textScaleFactor {
    if (super.textScaleFactor == null) return textSizeTimes;
    return super.textScaleFactor;
  }
}
