import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../data/ad_helper.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  static final _kAdIndex = 4;

  static BannerAd? _ad;
  bool isShowBanner = false;

  @override
  void initState() {
    super.initState();
      var add=BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) async{
            setState(() {
              isShowBanner = true;
              _ad = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Releases an ad resource when it fails to load
            ad.dispose();
          },
        ),
      );
      add.dispose();
      add.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 23),
      width: MediaQuery.of(context).size.width,
      height: 48,
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
