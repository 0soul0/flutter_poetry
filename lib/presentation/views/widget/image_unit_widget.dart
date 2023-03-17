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

  img() => Image.network(
        url,
        width: width,
      );

  svg() => SvgPicture.network(
        url,
        width: width,
        headers: const {
          'Content-Type': 'image/svg+xml',
        },
        placeholderBuilder: (BuildContext context) => Container(
            padding: EdgeInsets.zero, child: const Center(child: CircularProgressIndicator())),
      );
}
