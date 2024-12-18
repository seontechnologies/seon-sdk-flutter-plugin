import 'dart:async';
import 'package:flutter/services.dart';
import 'seon_sdk_flutter_plugin_platform_interface.dart';
import 'seon_sdk_geolocation_config.dart';

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
  void startBehaviourMonitoring() {
    try {
      _channel.invokeMethod(
          'startBehaviourMonitoring');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> stopBehaviourMonitoring(String? sessionId) async {
    try {
      final String? fingerprint = await _channel
          .invokeMethod('stopBehaviourMonitoring', {'sessionId': sessionId});
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

  @override
  void setGeolocationConfig(SeonGeolocationConfig config) {
    try {
      _channel.invokeMethod(
          'setGeolocationConfig', config.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
