import 'package:flutter/material.dart';

/// The class was used to manger touch event
class TouchUnitWidget extends GestureDetector {
  TouchUnitWidget({
    super.key,
    super.child,
    this.onTapDelay,
    super.onDoubleTap,
    super.onLongPress,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    bool? enableFeedback = true,
    super.excludeFromSemantics,
  });

  final GestureTapCallback? onTapDelay;

  bool onTapEnable = true;

  @override
  GestureTapCallback? get onTap => () {
        if (onTapEnable && onTapDelay != null) {
          onTapDelay!();
        }
        onTapEnable = false;
        onDelayed(() {
          onTapEnable = true;
        });
        super.onTap;
      };

  onDelayed(Function func, {int delayTime = 300}) {
    Future.delayed(Duration(milliseconds: delayTime)).then((value) => func());
  }
}
