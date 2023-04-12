import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_poetry/presentation/views/widget/touch_unit_widget.dart';
import 'package:flutter_poetry/presentation/views/widget/widget_to_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'load_image.dart';

class ImageUnitWidget extends StatefulWidget {
  const ImageUnitWidget(this.url, this.width, {Key? key, this.callBack})
      : super(key: key);
  final String url;
  final double width;
  final Function? callBack;

  @override
  State<ImageUnitWidget> createState() => _ImageUnitWidgetState();
}

class _ImageUnitWidgetState extends State<ImageUnitWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.toLowerCase().contains(".svg")) {
      return svgImage();
    }

    var networkImage = NetworkImage(widget.url);
    ImageStream imageStream =
        Image(image: networkImage).image.resolve(ImageConfiguration.empty);
    _download(imageStream);
    return img(context, networkImage);
  }

  // _svgToPng(String url) async {
  //   final response = await Dio().get(
  //     "https://www.svgrepo.com/show/513959/alt-bell.svg",
  //   );
  //   final DrawableRoot svgR = await svg.fromSvgString(
  //       response.data.toString(), response.data.toString());
  //   final Picture picture = svgR.toPicture();
  //   final ui.Image image =
  //       await picture.toImage(1,1);
  //   final ByteData? byteData =
  //       await image.toByteData(format: ui.ImageByteFormat.png);
  //   var imageData = byteData?.buffer.asUint8List() ?? Uint8List(0);
  //   final Directory tempDir = await getTemporaryDirectory();
  //   final File file =
  //       File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
  //   await file.writeAsBytes(imageData.buffer.asUint8List(), flush: true);
  //   widget.callBack!(file.path);
  // }

  _download(ImageStream imageStream) async {
    final Completer completer = Completer<void>();
    imageStream.addListener(ImageStreamListener((image, synchronousCall) async {
      completer.complete();
      final ByteData? imageData =
          await image.image.toByteData(format: ui.ImageByteFormat.png);
      if (imageData != null) {
        final Directory tempDir = await getTemporaryDirectory();
        final File file = File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(imageData.buffer.asUint8List(), flush: true);
        widget.callBack!(file.path);
      }
    }));
    await completer.future;
  }

  img(
    context,
    networkImage,
  ) =>
      SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: PhotoView(
          imageProvider: networkImage,
          basePosition: Alignment.center,
          backgroundDecoration: const BoxDecoration(color: Colors.white),
          loadingBuilder: (context, progress) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

  svgImage() => SvgPicture.network(
        widget.url,
        width: widget.width,
        placeholderBuilder: (BuildContext context) => Container(
            padding: EdgeInsets.zero,
            child: const Center(child: CircularProgressIndicator())),
      );
}
