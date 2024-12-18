import 'seon_sdk_flutter_plugin_platform_interface.dart';
import 'seon_sdk_geolocation_config.dart';

class SeonSdkFlutterPlugin {
  Future<String?> getFingerprint(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.getFingerprint(sessionId);
  }
  void startBehaviourMonitoring() {
    return SeonSdkFlutterPluginPlatform.instance.startBehaviourMonitoring();
  }
  Future<String?> stopBehaviourMonitoring(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.stopBehaviourMonitoring(sessionId);
  }
  void setGeolocationEnabled(bool enabled) {
    return SeonSdkFlutterPluginPlatform.instance.setGeolocationEnabled(enabled);
  }

  void setGeolocationTimeout(int timeoutInMillisec) {
    return SeonSdkFlutterPluginPlatform.instance
        .setGeolocationTimeout(timeoutInMillisec);
  }

  void setGeolocationConfig(SeonGeolocationConfig config) {
    return SeonSdkFlutterPluginPlatform.instance
        .setGeolocationConfig(config);
  }
}
