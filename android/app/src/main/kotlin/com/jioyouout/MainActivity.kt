package com.jioyouout

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        provideFlutterEngine(this)?.let { GeneratedPluginRegistrant.registerWith(it) }
//        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
//            if (call.method.equals("StartSecondActivity")) {
//                val intent = Intent(this, KotlinActivity::class.java)
//                startActivity(intent)
//                result.success("ActivityStarted")
//            } else {
//                result.notImplemented()
//            }
//        }
    }
}
