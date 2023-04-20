import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageUnitWidget extends StatefulWidget {
  const ImageUnitWidget(this.file, this.width, {Key? key, this.callBack})
      : super(key: key);
  final File file;
  final double width;
  final Function? callBack;

  @override
  State<ImageUnitWidget> createState() => _ImageUnitWidgetState();
}

class _ImageUnitWidgetState extends State<ImageUnitWidget> {
  Map<String, File> cachePath = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.url.toLowerCase().contains(".svg")) {
    //   return svgImage();
    // }

    // var networkImage = NetworkImage(widget.file);

    // if (!cachePath.containsKey(widget.url)) {
    //   _download(networkImage);
    // }else{
    //   widget.callBack!(cachePath[widget.url]?.path);
    // }

    return img(context);
  }

  // _download(networkImage) async {
  //   ImageStream imageStream =
  //       Image(image: networkImage).image.resolve(ImageConfiguration.empty);
  //   final Completer completer = Completer<void>();
  //   imageStream.addListener(ImageStreamListener((image, synchronousCall) async {
  //     completer.complete();
  //     final ByteData? imageData =
  //         await image.image.toByteData(format: ui.ImageByteFormat.png);
  //     if (imageData != null) {
  //       final Directory tempDir = await getTemporaryDirectory();
  //       final File file = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
  //       await file.writeAsBytes(imageData.buffer.asUint8List(), flush: true);
  //       widget.callBack!(file.path);
  //     }
  //   }));
  //   await completer.future;
  // }

  img(
    context,
  ) => SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: PhotoView(
          imageProvider: FileImage(widget.file),
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

  // svgImage() => SvgPicture.network(
  //       widget.url,
  //       width: widget.width,
  //       placeholderBuilder: (BuildContext context) => Container(
  //           padding: EdgeInsets.zero,
  //           child: const Center(child: CircularProgressIndicator())),
  //     );
}
