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
  Future<void> startBehaviourMonitoring() async {
    try {
      await _channel.invokeMethod(
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
  Future<void> setGeolocationEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod('setGeolocationEnabled', {'enabled': enabled});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setGeolocationTimeout(int timeoutInMillisec) async {
    try {
      await _channel.invokeMethod(
          'setGeolocationTimeout', {'timeoutInMillisec': timeoutInMillisec});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setGeolocationConfig(SeonGeolocationConfig config) async {
    try {
      await _channel.invokeMethod(
          'setGeolocationConfig', config.toMap());
    } catch (e) {
      rethrow;
    }
  } 

  @override
  Future<void> setDnsTimeout(int timeoutInMillisec) async {
    try {
      await _channel.invokeMethod('setDnsTimeout', {'timeoutInMillisec': timeoutInMillisec});
    } catch (e) {
      rethrow;
    }
  }
}
