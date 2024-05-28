import 'seon_sdk_flutter_plugin_platform_interface.dart';

class SeonSdkFlutterPlugin {
  Future<String?> getFingerprint(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.getFingerprint(sessionId);
  }

  Future<void> setGeolocationEnabled(bool enabled) async {
    return SeonSdkFlutterPluginPlatform.instance.setGeolocationEnabled(enabled);
  }
}
