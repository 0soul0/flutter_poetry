import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_poetry/tool/extension.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final GlobalKey keyGlobal;

  const ScrollToHideWidget(
      {Key? key,
      required this.keyGlobal,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 200)})
      : super(key: key);

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    // if (widget.controller.position.pixels >= 200) {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      hide();
    } else if (direction == ScrollDirection.reverse) {
      show();
    }
  }

  void show() {
    if (!isVisible) setState(() => isVisible = true);
  }

  void hide() {
    if (isVisible) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    RenderBox? renderBox =
        widget.keyGlobal.currentContext?.findRenderObject() as RenderBox?;
    var height = renderBox?.size.height;

    if (height == null) {
      isVisible = false;
      widget.controller.removeListener(listen);
    }

    return AnimatedContainer(
      color: Colors.green,
      duration: widget.duration,
      height: isVisible ? height : 0,
      child: Wrap(children: [widget.child]),
    );
  }
}
