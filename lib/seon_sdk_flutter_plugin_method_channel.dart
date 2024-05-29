import 'dart:async';
import 'package:flutter/services.dart';
import 'seon_sdk_flutter_plugin_platform_interface.dart';

class SeonSdkWrapper extends SeonSdkFlutterPluginPlatform {
  static const MethodChannel _channel =
      MethodChannel('seon_sdk_flutter_plugin');

  @override
  Future<String?> getFingerprint(String? sessionId) async {
    try {
      final String? fingerprint = await _channel
          .invokeMethod('getFingerprint', {'sessionId': sessionId});
      return fingerprint;
    } on PlatformException catch (e) {
      print("Failed to get fingerprint: ${e.message}");
      return null;
    } catch (e) {
      print("An error occured while getting the fingerprint: $e");
      return null;
    }
  }

  @override
  Future<void> setGeolocationEnabled(bool enabled) async {
    try {
      await _channel
          .invokeMethod('setGeolocationEnabled', {'enabled': enabled});
    } on PlatformException catch (e) {
      print("Failed to enable geolocation: ${e.message}");
    } catch (e) {
      print("An error occured when enabling Geolocation: $e");
    }
  }

  @override
  void setGeolocationTimeout(int timeoutInMillisec) {
    try {
      _channel.invokeMethod(
          'setGeolocationTimeout', {'timeoutInMillisec': timeoutInMillisec});
    } catch (e) {
      print("Error while setting Geolocation Timeout: $e");
    }
  }
}
