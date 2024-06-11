import 'package:flutter_test/flutter_test.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_platform_interface.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSeonSdkFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements SeonSdkFlutterPluginPlatform {
  String expectedFingerprint = 'Test_Fingerprint';

  @override
  Future<String?> getFingerprint(String? sessionId) {
    return Future.value(expectedFingerprint);
  }

  @override
  void setGeolocationEnabled(bool enabled) {}

  @override
  void setGeolocationTimeout(int timeoutInMillisec) {}
}

String expectedFingerprint = 'Test_Fingerprint';
void main() {
  final SeonSdkFlutterPluginPlatform initialPlatform =
      SeonSdkFlutterPluginPlatform.instance;

  test('$SeonSdkWrapper is the default instance', () {
    expect(initialPlatform, isInstanceOf<SeonSdkWrapper>());
  });

  test('getFingerprint', () async {
    SeonSdkFlutterPlugin seonSdkFlutterPlugin = SeonSdkFlutterPlugin();
    MockSeonSdkFlutterPluginPlatform fakePlatform =
        MockSeonSdkFlutterPluginPlatform();
    SeonSdkFlutterPluginPlatform.instance = fakePlatform;

    expect(await seonSdkFlutterPlugin.getFingerprint('test-session-id'),
        expectedFingerprint);
  });
  test('setGeolocationEnabled', () async {
    SeonSdkFlutterPlugin seonSdkFlutterPlugin = SeonSdkFlutterPlugin();
    MockSeonSdkFlutterPluginPlatform fakePlatform =
        MockSeonSdkFlutterPluginPlatform();
    SeonSdkFlutterPluginPlatform.instance = fakePlatform;

    // Call the method and ensure no exceptions
    seonSdkFlutterPlugin.setGeolocationEnabled(true);
  });

  test('setGeolocationTimeout', () async {
    SeonSdkFlutterPlugin seonSdkFlutterPlugin = SeonSdkFlutterPlugin();
    MockSeonSdkFlutterPluginPlatform fakePlatform =
        MockSeonSdkFlutterPluginPlatform();
    SeonSdkFlutterPluginPlatform.instance = fakePlatform;

    // Call the method and ensure no exceptions
    seonSdkFlutterPlugin.setGeolocationTimeout(400);
  });
}
