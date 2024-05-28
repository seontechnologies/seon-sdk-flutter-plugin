import 'seon_sdk_flutter_plugin_platform_interface.dart';

class SeonSdkFlutterPlugin {
  Future<String?> getFingerprint(String? sessionId) async {
    return SeonSdkFlutterPluginPlatform.instance.getFingerprint(sessionId);
  }

  Future<void> enableGeolocation() async {
    return SeonSdkFlutterPluginPlatform.instance.enableGeolocation();
  }
}
