import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageUnitWidget extends StatelessWidget {
  const ImageUnitWidget(this.url, this.width, {super.key});

  final String url;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (url.toLowerCase().contains(".svg")) {
      return svg();
    }
    return img();
  }

  img() => ExtendedImage.network(
        url,
        width: width,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        initGestureConfigHandler: (state) {
          return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: false);
        },
      );

  svg() => SvgPicture.network(
        url,
        width: width,
        headers: const {
          'Content-Type': 'image/svg+xml',
        },
        placeholderBuilder: (BuildContext context) => Container(
            padding: EdgeInsets.zero,
            child: const Center(child: CircularProgressIndicator())),
      );
}
