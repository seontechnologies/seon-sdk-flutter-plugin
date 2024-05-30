import 'seon_sdk_flutter_plugin_platform_interface.dart';

class SeonSdkFlutterPlugin {
  Future<String?> getFingerprint(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.getFingerprint(sessionId);
  }

  void setGeolocationEnabled(bool enabled) {
    return SeonSdkFlutterPluginPlatform.instance.setGeolocationEnabled(enabled);
  }

  void setGeolocationTimeout(int timeoutInMillisec) {
    return SeonSdkFlutterPluginPlatform.instance
        .setGeolocationTimeout(timeoutInMillisec);
  }
}
