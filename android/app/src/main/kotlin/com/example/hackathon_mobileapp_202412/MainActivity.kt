package com.example.hackathon_mobileapp_202412

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter_web_auth"
    private var result: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "authenticate") {
                val url = call.argument<String>("url")
                val callbackUrlScheme = call.argument<String>("callbackUrlScheme")
                val preferEphemeral = call.argument<Boolean>("preferEphemeral") ?: false

                // 認証処理を開始
                this.result = result
                println("Starting authentication with URL: $url and callbackUrlScheme: $callbackUrlScheme")
                startAuthentication(url, callbackUrlScheme, preferEphemeral)
            } else {
                result.notImplemented()
            }
        }

    }

    private fun startAuthentication(url: String?, callbackUrlScheme: String?, preferEphemeral: Boolean) {
        if (url == null || callbackUrlScheme == null) {
            result?.error("INVALID_ARGUMENT", "URL or callbackUrlScheme is null", null)
            return
        }

        // Webブラウザを開いて認証を開始
        println("Opening browser with URL: $url")
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        if (preferEphemeral) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            println("Using ephemeral session")
            
        }

        startActivity(intent)
        
    }

    override fun onNewIntent(intent: Intent) {
        println(intent);
        super.onNewIntent(intent)
        val uri = intent.data
        println("onNewIntent called with URI: $uri")
        if (uri != null && uri.toString().startsWith("http")) { // カスタムスキームを使用
            println("Received callback URL: $uri")
            result?.success(uri.toString())
            result = null
        } else {
            println("No callback URL received or URL does not match scheme")
        }
    }
    // private fun handleNewIntent(intent: Intent) {
    //     println("あ")
    //     val uri = intent.data
    //     println("handleNewIntent called with URI: $uri")
    //     if (uri != null && uri.toString().startsWith("http://10.0.2.2:3000/callback")) { // カスタムスキームを使用
    //         println("Received callback URL: $uri")
    //         result?.success(uri.toString())
    //         result = null
    //     } else {
    //         println("No callback URL received or URL does not match scheme")
    //     }
    // }

}
