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
import io.seon.androidsdk.service.SeonCallbackWithGeo;
import io.seon.androidsdk.service.SeonCallback;

/** SeonSdkFlutterPlugin */
class SeonSdkFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private var geolocationConfig: SeonGeolocationConfig = SeonGeolocationConfigBuilder().build()
    private var seonFingerprint: Seon? = null
    private var sessionId: String = UUID.randomUUID().toString()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "seon_sdk_flutter_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    // Android specific default GeolocationConfig parameters can be modified here
    geolocationConfig = SeonGeolocationConfigBuilder()
      .withPrefetchEnabled(true)
      .withGeolocationServiceTimeoutMs(3000)
      .withMaxGeoLocationCacheAgeSec(600)
      .build()
    seonFingerprint = getSeonObject()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
      when (call.method) {
        "getFingerprint" -> {
            val newSessionId = call.argument<String>("sessionId")
            if (newSessionId == null) {
                result.error("SEON_INVALID_ARGUMENT", "sessionId is required", null)
                return
            }
            setSessionId(newSessionId)
            getFingerprint(newSessionId, result)
        }
        "startBehaviourMonitoring" -> {
            startBehaviourMonitoring()
        }
        "stopBehaviourMonitoring" -> {
            val newSessionId = call.argument<String>("sessionId")
            if (newSessionId == null) {
                result.error("SEON_INVALID_ARGUMENT", "sessionId is required", null)
                return
            }
            setSessionId(newSessionId)
            stopBehaviourMonitoring(sessionId, result)
        }
        "setGeolocationEnabled" -> {
            val isGeoEnabled = call.argument<Boolean?>("enabled")
            if (isGeoEnabled!=null) {
                setGeolocationEnabled(isGeoEnabled)
            }
            result.success(null)
        }
        "setGeolocationTimeout" -> {
            val timeoutInMs = call.argument<Int>("timeoutInMillisec")
            if (timeoutInMs != null){
                Log.d("SEON","geo timeout: $timeoutInMs")
                setGeolocationTimeout(timeoutInMs)
            }
            result.success(null);
        }
        "setGeolocationConfig" -> {
            val timeoutInMs = call.argument<Int>("geolocationServiceTimeoutMs") ?: SeonGeolocationConfig.kDefaultLocationServiceTimeoutMs
            val maxCacheAgeSec = call.argument<Int>("maxGeoLocationCacheAgeSec") ?: SeonGeolocationConfig.kDefaultMaxLocationCacheAgeSec
            val isPrefetchEnabled = call.argument<Boolean>("prefetchEnabled") ?: SeonGeolocationConfig.kDefaultPrefetchEnabled
            val isGeolocationEnabled = call.argument<Boolean>("geolocationEnabled") ?: SeonGeolocationConfig.kDefaultGeolocationEnabled
            if (timeoutInMs != null && maxCacheAgeSec != null && isPrefetchEnabled != null && isGeolocationEnabled != null){
                var config = SeonGeolocationConfigBuilder()
                    .withPrefetchEnabled(isPrefetchEnabled)
                    .withGeolocationServiceTimeoutMs(timeoutInMs)
                    .withMaxGeoLocationCacheAgeSec(maxCacheAgeSec)
                    .withGeolocationEnabled(isGeolocationEnabled)
                    .build()
                geolocationConfig = config
                getSeonObject().setGeoLocationConfig(geolocationConfig)
//                getSeonObject().setGeolocationEnabled(isGeolocationEnabled)
            }
            result.success(null);
        }
        else -> result.notImplemented()
    }
  }

  private fun getFingerprint(sessionId: String, result: Result) {
    try {
        if(geolocationConfig.isGeolocationEnabled()) {
            getSeonObject().getFingerprintBase64(object : SeonCallbackWithGeo {
                override fun onComplete(response: String) {
                    if(response != null) {
                        result.success(response)
                    } else {
                        result.error("SEON_ERROR", "Failed to get fingerprint", null)
                    }
                }
                override fun onCompleteWithGeoFailure(response: String, geoStatusCode: Int) {
                    if(response == null) {
                        result.error("SEON_ERROR", "Failed to get fingerprint", null)
                    } else {
                        result.error("SEON_GEO_FAILURE_CODE:$geoStatusCode", response, null)
                    }
                }
            })
        }
        else {
            getSeonObject().getFingerprintBase64 { fingerprint ->
                if (fingerprint != null) {
                    result.success(fingerprint)
                } else {
                    result.error("SEON_ERROR", "Failed to get fingerprint", null)
                }
            }
        }
    } catch (e: SeonException) {
        e.printStackTrace()
        result.error("SEON_EXCEPTION", e.message, null)
    }
  }

  private fun setGeolocationEnabled(enabled:Boolean) {
      geolocationConfig.isGeolocationEnabled = enabled
  }

  private fun setGeolocationTimeout(timeoutInMilliseconds:Int){
      geolocationConfig.geolocationServiceTimeoutMs = timeoutInMilliseconds
  }
  private fun startBehaviourMonitoring() {
    getSeonObject().startBehaviourMonitoring()
  }
  private fun stopBehaviourMonitoring(sessionId: String, result: Result) {
    try {
        if(geolocationConfig.isGeolocationEnabled()) {
            getSeonObject().stopBehaviourMonitoring(object : SeonCallbackWithGeo {
                override fun onComplete(response: String) {
                    if(response != null) {
                        result.success(response)
                    } else {
                        result.error("SEON_ERROR", "Failed to get fingerprint", null)
                    }
                }
                override fun onCompleteWithGeoFailure(response: String, geoStatusCode: Int) {
                    if(response == null) {
                        result.error("SEON_ERROR", "Failed to get fingerprint", null)
                    } else {
                        result.error("SEON_GEO_FAILURE_CODE:$geoStatusCode", response, null)
                    }
                }
            })
        }
        else {
            getSeonObject().getFingerprintBase64 { fingerprint ->
                if (fingerprint != null) {
                    result.success(fingerprint)
                } else {
                    result.error("SEON_ERROR", "Failed to get fingerprint", null)
                }
            }
        }
    } catch (e: SeonException) {
        e.printStackTrace()
        result.error("SEON_EXCEPTION", e.message, null)
    }
  }
  private fun getSeonObject(): Seon {
    if(seonFingerprint == null) {
        seonFingerprint = SeonBuilder()
        .withContext(context)
        .withSessionId(sessionId)
        .withGeoLocationConfig(geolocationConfig)
        .build()
    }
    val nonNullableSeon: Seon = seonFingerprint!!
    nonNullableSeon.setLoggingEnabled(true)
    return nonNullableSeon
  }
  private fun setSessionId(newSessionId: String) {
    sessionId = newSessionId;
    getSeonObject().sessionId = newSessionId;
  }
}
