import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  SeonSdkWrapper platform = SeonSdkWrapper();
  const MethodChannel channel = MethodChannel('seon_sdk_flutter_plugin');
  String expectedFingerprint = 'Test_Fingerprint';

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getFingerprint':
            return expectedFingerprint;
          case 'setGeolocationEnabled':
            return null;
          case 'setGeolocationTimeout':
            return null;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getFingerprint', () async {
    String testSessionId = 'test-session-id';
    expect(await platform.getFingerprint(testSessionId), expectedFingerprint);
  });

  test('setGeolocationEnabled', () async {
    bool enabled = true;
    platform.setGeolocationEnabled(enabled);
    // No assertion needed, just ensure no exceptions
  });

  test('setGeolocationTimeout', () async {
    int timeoutInMillisec = 3000;
    platform.setGeolocationTimeout(timeoutInMillisec);
    // No assertion needed, just ensure no exceptions
  });
}
