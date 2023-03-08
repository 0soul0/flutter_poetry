import 'package:flutter/material.dart';

/// The class was used to manger touch event
class TouchUnitWidget extends InkWell {
  TouchUnitWidget({
    super.key,
    super.child,
    this.onTapDelay,
    super.onDoubleTap,
    super.onLongPress,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    super.onHighlightChanged,
    super.onHover,
    super.mouseCursor,
    super.focusColor,
    super.hoverColor,
    super.highlightColor,
    super.overlayColor,
    super.splashColor,
    super.splashFactory,
    super.radius,
    super.borderRadius,
    super.customBorder,
    bool? enableFeedback = true,
    super.excludeFromSemantics,
    super.focusNode,
    super.canRequestFocus,
    super.onFocusChange,
    super.autofocus,
    super.statesController,
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
