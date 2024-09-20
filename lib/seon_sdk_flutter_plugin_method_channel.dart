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
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setGeolocationEnabled(bool enabled) {
    try {
      _channel.invokeMethod('setGeolocationEnabled', {'enabled': enabled});
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setGeolocationTimeout(int timeoutInMillisec) {
    try {
      _channel.invokeMethod(
          'setGeolocationTimeout', {'timeoutInMillisec': timeoutInMillisec});
    } catch (e) {
      rethrow;
    }
  }
}
