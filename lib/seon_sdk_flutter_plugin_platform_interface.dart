import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'seon_sdk_flutter_plugin_method_channel.dart';

abstract class SeonSdkFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a SeonSdkFlutterPluginPlatform.
  SeonSdkFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SeonSdkFlutterPluginPlatform _instance = SeonSdkWrapper();

  /// The default instance of [SeonSdkFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSeonSdkFlutterPlugin].
  static SeonSdkFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SeonSdkFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(SeonSdkFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getFingerprint(String? sessionId) async {
    return _instance.getFingerprint(sessionId);
  }

  Future<void> enableGeolocation() async {
    _instance.enableGeolocation();
  }
}
