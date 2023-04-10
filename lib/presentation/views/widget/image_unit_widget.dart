import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'load_image.dart';

class ImageUnitWidget extends StatelessWidget {
  const ImageUnitWidget(this.url, this.width, {super.key, this.callBack});

  final String url;
  final double width;
  final Function? callBack;

  @override
  Widget build(BuildContext context) {

    if (url.toLowerCase().contains(".svg")) {
      return FutureBuilder(
        future: svgPictureToImage(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              // ImageStream imageStream = snapshot.data.image.resolve(ImageConfiguration.empty);
              // _download(imageStream);
              return img(context, snapshot.data);
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }

    var networkImage = NetworkImage(url);
    ImageStream imageStream = Image(image: networkImage).image.resolve(ImageConfiguration.empty);
    _download(imageStream);
    // _download(imageStream);
    return img(context, networkImage);
  }

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
        callBack!(file.path);
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

  svgPictureToImage() async {
    final response = await Dio().get(url);
    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(response.data), null);
    ui.Image image = await pictureInfo.picture.toImage(
      200,
      200,
    );
    pictureInfo.picture.dispose();
    return LoadImage(image);
  }

// svgImage() async {
//   final response = await Dio().get(url);
//   // return SvgPicture.network(
//   //   url,
//   //   width: width,
//   //   // headers: const {
//   //   //   'Content-Type': 'image/svg',
//   //   // },
//   //   placeholderBuilder: (BuildContext context) => Container(
//   //       padding: EdgeInsets.zero,
//   //       child: const Center(child: CircularProgressIndicator())),
//   // );
// }
}
