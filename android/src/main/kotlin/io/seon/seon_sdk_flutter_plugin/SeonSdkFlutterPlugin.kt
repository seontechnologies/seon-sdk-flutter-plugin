package io.seon.seon_sdk_flutter_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context;
import android.util.Log
import java.util.UUID;
import io.seon.androidsdk.BuildConfig;
import io.seon.androidsdk.dto.SeonGeolocationConfig;
import io.seon.androidsdk.dto.SeonGeolocationConfigBuilder;
import io.seon.androidsdk.exception.SeonException;
import io.seon.androidsdk.service.Seon;
import io.seon.androidsdk.service.SeonBuilder;

/** SeonSdkFlutterPlugin */
class SeonSdkFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private var geolocationConfig: SeonGeolocationConfig = SeonGeolocationConfigBuilder().build()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "seon_sdk_flutter_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
      when (call.method) {
        "getFingerprint" -> {
            val sessionId = call.argument<String>("sessionId")
            if (sessionId == null) {
                result.error("INVALID_ARGUMENT", "sessionId is required", null)
                return
            }
            getFingerprint(sessionId, result)
        }
        "setGeolocationEnabled" -> {
            val isGeoEnabled = call.argument<Boolean?>("enabled")
            if (isGeoEnabled!=null) {
                setGeolocationEnabled(isGeoEnabled)
            }
            result.success(null)
        }
        else -> result.notImplemented()
    }
  }

  private fun getFingerprint(sessionId: String, result: Result) {
    val seonFingerprint = SeonBuilder()
        .withContext(context)
        .withSessionId(sessionId)
        .withGeoLocationConfig(geolocationConfig)
        .build()

    seonFingerprint.setLoggingEnabled(true)

    try {
        seonFingerprint.getFingerprintBase64 { fingerprint ->
            if (fingerprint != null) {
                result.success(fingerprint)
            } else {
                result.error("SEON_ERROR", "Failed to get fingerprint", null)
            }
        }
    } catch (e: SeonException) {
        e.printStackTrace()
        result.error("SEON_EXCEPTION", e.message, null)
    }
  }

  private fun setGeolocationEnabled(enabled:Boolean) {
      geolocationConfig = SeonGeolocationConfigBuilder()
          .withPrefetchEnabled(true)
          .withGeolocationEnabled(enabled)
          .withGeolocationServiceTimeoutMs(3000)
          .withMaxGeoLocationCacheAgeSec(600)
          .build()
  }
}
