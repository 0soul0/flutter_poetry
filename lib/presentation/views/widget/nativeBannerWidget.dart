import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeBannerWidget extends StatefulWidget {
  NativeBannerWidget(this.height, {Key? key}) : super(key: key);

  NativeAd? myNative;
  bool isShowBanner = false;
  double height;

  @override
  State<NativeBannerWidget> createState() => _NativeBannerWidgetState();
}

class _NativeBannerWidgetState extends State<NativeBannerWidget> {
  @override
  void initState() {
    banner();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {}

  banner() {
    widget.myNative = NativeAd(
      adUnitId: 'ca-app-pub-9515998171000409/4199099846',
      factoryId: 'adFactoryExample',
      request: const AdRequest(),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => {
          setState(() {
            widget.isShowBanner = true;
          }),
          myLog('Ad1 loaded.')
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          widget.isShowBanner = false;
          ad.dispose();
          myLog('Ad1 failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => myLog('Ad1 opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => myLog('Ad1 closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => myLog('Ad1 impression.'),
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (Ad ad) => myLog('Ad1 impression.'),
      ),
    );
    widget.myNative!.load();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isShowBanner
        ? Container(
            alignment: Alignment.center,
            width: ScreenUtil.defaultSize.width,
            height: widget.height,
            child: AdWidget(ad: widget.myNative!),
          )
        : SizedBox(
            width: ScreenUtil.defaultSize.width,
            height: widget.height,
          );
  }
}
