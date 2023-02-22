import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/AdHelper.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  static final _kAdIndex = 4;

  BannerAd? _ad;
  bool isShowBanner = false;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isShowBanner = true;
            _ad = ad as BannerAd;
          });
          print('Ad load success');
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 72.0,
      alignment: Alignment.center,
      child: isShowBanner
          ? AdWidget(
              ad: _ad!,
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }
}
