import 'package:flutter/material.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';

class SelectTableWidget extends SelectableText {

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
    if (super.textScaleFactor == null) return TextUnitWidget.textSizeTimes;
    return super.textScaleFactor;
  }
}
