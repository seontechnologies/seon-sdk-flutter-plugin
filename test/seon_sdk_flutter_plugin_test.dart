import 'package:flutter_test/flutter_test.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_platform_interface.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSeonSdkFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements SeonSdkFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SeonSdkFlutterPluginPlatform initialPlatform = SeonSdkFlutterPluginPlatform.instance;

  test('$MethodChannelSeonSdkFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSeonSdkFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    SeonSdkFlutterPlugin seonSdkFlutterPlugin = SeonSdkFlutterPlugin();
    MockSeonSdkFlutterPluginPlatform fakePlatform = MockSeonSdkFlutterPluginPlatform();
    SeonSdkFlutterPluginPlatform.instance = fakePlatform;

    expect(await seonSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
