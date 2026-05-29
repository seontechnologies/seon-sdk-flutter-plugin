import 'seon_sdk_flutter_plugin_platform_interface.dart';
import 'seon_sdk_geolocation_config.dart';

class SeonSdkFlutterPlugin {
  Future<String?> getFingerprint(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.getFingerprint(sessionId);
  }
  Future<void> startBehaviourMonitoring() async {
    return SeonSdkFlutterPluginPlatform.instance.startBehaviourMonitoring();
  }
  Future<String?> stopBehaviourMonitoring(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.stopBehaviourMonitoring(sessionId);
  }
  Future<void> setGeolocationEnabled(bool enabled) async {
    return SeonSdkFlutterPluginPlatform.instance.setGeolocationEnabled(enabled);
  }

  Future<void> setGeolocationTimeout(int timeoutInMillisec) async {
    return SeonSdkFlutterPluginPlatform.instance
        .setGeolocationTimeout(timeoutInMillisec);
  }

  Future<void> setGeolocationConfig(SeonGeolocationConfig config) async {
    return SeonSdkFlutterPluginPlatform.instance
        .setGeolocationConfig(config);
  }

  Future<void> setDnsTimeout(int timeoutInMillisec) async {
    return SeonSdkFlutterPluginPlatform.instance
        .setDnsTimeout(timeoutInMillisec);
  }
}
