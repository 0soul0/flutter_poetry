package com.example.flutter_poetry

import android.view.LayoutInflater
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "adFactoryExample",
            NativeAdFactoryExample(LayoutInflater.from(this))
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine){
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample")
    }

}
