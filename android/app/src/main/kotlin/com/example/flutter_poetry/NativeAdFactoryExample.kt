package com.example.flutter_poetry

import android.annotation.SuppressLint
import android.graphics.Color
import android.view.LayoutInflater
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory


class NativeAdFactoryExample : NativeAdFactory {
    private var layoutInflater: LayoutInflater? = null

    constructor(layoutInflater: LayoutInflater?) {
        this.layoutInflater = layoutInflater
    }

    constructor()

    @SuppressLint("InflateParams")
    override fun createNativeAd(
        nativeAd: NativeAd, customOptions: Map<String?, Any?>?
    ): NativeAdView {
        val adView = layoutInflater?.inflate(R.layout.my_native_ad, null) as NativeAdView
        val headlineView: TextView = adView.findViewById(R.id.ad_headline)
        val bodyView: TextView = adView.findViewById(R.id.ad_body)
        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body
        adView.setBackgroundColor(Color.YELLOW)
        adView.setNativeAd(nativeAd)
        adView.bodyView = bodyView
        adView.headlineView = headlineView
        return adView
    }
}