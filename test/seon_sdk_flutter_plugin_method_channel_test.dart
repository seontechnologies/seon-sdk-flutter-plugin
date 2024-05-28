import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSeonSdkFlutterPlugin platform = MethodChannelSeonSdkFlutterPlugin();
  const MethodChannel channel = MethodChannel('seon_sdk_flutter_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
