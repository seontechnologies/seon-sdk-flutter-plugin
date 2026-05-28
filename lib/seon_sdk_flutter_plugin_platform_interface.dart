import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'seon_sdk_flutter_plugin_method_channel.dart';
import 'seon_sdk_geolocation_config.dart';

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
  Future<void> startBehaviourMonitoring() async {
    return _instance.startBehaviourMonitoring();
  }
  Future<String?> stopBehaviourMonitoring(String? sessionId) async {
    return _instance.stopBehaviourMonitoring(sessionId);
  }
  Future<void> setGeolocationEnabled(bool enabled) async {
    return _instance.setGeolocationEnabled(enabled);
  }

  Future<void> setGeolocationTimeout(int timeoutInMillisec) async {
    return _instance.setGeolocationTimeout(timeoutInMillisec);
  }

  Future<void> setGeolocationConfig(SeonGeolocationConfig config) async {
    return _instance.setGeolocationConfig(config);
  }
}
