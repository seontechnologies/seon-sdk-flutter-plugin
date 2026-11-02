import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_method_channel.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin_platform_interface.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_geolocation_config.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_geolocation_config_builder.dart';

class RecordedCall {
  final String method;
  final Object? arguments;

  RecordedCall(this.method, this.arguments);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('seon_sdk_flutter_plugin');
  late List<RecordedCall> calls;
  late SeonSdkFlutterPlugin plugin;

  List<String> methods() => calls.map((c) => c.method).toList();

  Object? argumentsOf(String method) =>
      calls.lastWhere((c) => c.method == method).arguments;

  setUp(() {
    calls = [];
    SeonSdkFlutterPluginPlatform.instance = SeonSdkWrapper();
    plugin = SeonSdkFlutterPlugin();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      calls.add(RecordedCall(call.method, call.arguments));
      switch (call.method) {
        case 'getFingerprint':
        case 'stopBehaviourMonitoring':
          return 'fingerprint';
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize sends no arguments and no configuration', () async {
    await plugin.initialize();

    expect(methods(), ['initialize']);
    expect(calls.single.arguments, isNull);
  });

  test('setters called before initialize keep their order and values',
      () async {
    final config = SeonGeolocationConfigBuilder()
        .withGeolocationEnabled(true)
        .withLocationServiceTimeoutMs(5000)
        .withPrefetchEnabled(false)
        .withMaxLocationCacheAgeSec(42)
        .build();

    await plugin.setDnsTimeout(1234);
    await plugin.setGeolocationConfig(config);
    await plugin.setGeolocationTimeout(7000);
    await plugin.setGeolocationEnabled(false);
    await plugin.initialize();

    expect(methods(), [
      'setDnsTimeout',
      'setGeolocationConfig',
      'setGeolocationTimeout',
      'setGeolocationEnabled',
      'initialize',
    ]);
    expect(calls[0].arguments, {'timeoutInMillisec': 1234});
    expect(calls[1].arguments, {
      'geolocationServiceTimeoutMs': 5000,
      'maxGeoLocationCacheAgeSec': 42,
      'prefetchEnabled': false,
      'geolocationEnabled': true,
    });
    expect(calls[2].arguments, {'timeoutInMillisec': 7000});
    expect(calls[3].arguments, {'enabled': false});
    expect(calls[4].arguments, isNull);
  });

  test('setters called after initialize keep their order and values',
      () async {
    await plugin.initialize();
    await plugin.setDnsTimeout(900);
    await plugin.setGeolocationEnabled(true);
    await plugin.setGeolocationTimeout(2500);

    expect(methods(), [
      'initialize',
      'setDnsTimeout',
      'setGeolocationEnabled',
      'setGeolocationTimeout',
    ]);
    expect(calls[1].arguments, {'timeoutInMillisec': 900});
    expect(calls[2].arguments, {'enabled': true});
    expect(calls[3].arguments, {'timeoutInMillisec': 2500});
  });

  test('setters interleaved around initialize all reach the native side',
      () async {
    await plugin.setGeolocationEnabled(true);
    await plugin.initialize();
    await plugin.setGeolocationTimeout(4000);
    await plugin.setDnsTimeout(1500);

    expect(methods(), [
      'setGeolocationEnabled',
      'initialize',
      'setGeolocationTimeout',
      'setDnsTimeout',
    ]);
    expect(calls[0].arguments, {'enabled': true});
    expect(calls[2].arguments, {'timeoutInMillisec': 4000});
    expect(calls[3].arguments, {'timeoutInMillisec': 1500});
  });

  test('initialize does not resend or alter earlier configuration', () async {
    await plugin.setGeolocationConfig(SeonGeolocationConfig(
      locationServiceTimeoutMs: 1111,
      maxLocationCacheAgeSec: 22,
      prefetchEnabled: false,
      geolocationEnabled: true,
    ));
    final before = argumentsOf('setGeolocationConfig');

    await plugin.initialize();
    await plugin.initialize();

    expect(methods(), [
      'setGeolocationConfig',
      'initialize',
      'initialize',
    ]);
    expect(argumentsOf('setGeolocationConfig'), before);
  });

  test('last value wins when the same setter is called repeatedly', () async {
    await plugin.setGeolocationTimeout(1000);
    await plugin.setGeolocationTimeout(2000);
    await plugin.initialize();
    await plugin.setGeolocationTimeout(3000);

    final timeouts = calls
        .where((c) => c.method == 'setGeolocationTimeout')
        .map((c) => (c.arguments as Map)['timeoutInMillisec'])
        .toList();
    expect(timeouts, [1000, 2000, 3000]);
  });

  test('config object mutated through its setters is sent as mutated',
      () async {
    final config = SeonGeolocationConfig();
    config.geolocationEnabled = true;
    config.geolocationServiceTimeoutMs = 6500;
    config.maxGeoLocationCacheAgeSec = 99;
    config.prefetchEnabled = false;

    await plugin.setGeolocationConfig(config);

    expect(argumentsOf('setGeolocationConfig'), {
      'geolocationServiceTimeoutMs': 6500,
      'maxGeoLocationCacheAgeSec': 99,
      'prefetchEnabled': false,
      'geolocationEnabled': true,
    });
  });

  test('default config is sent with the documented defaults', () async {
    await plugin.setGeolocationConfig(SeonGeolocationConfig());

    expect(argumentsOf('setGeolocationConfig'), {
      'geolocationServiceTimeoutMs':
          SeonGeolocationConfig.kDefaultLocationServiceTimeoutMs,
      'maxGeoLocationCacheAgeSec':
          SeonGeolocationConfig.kDefaultMaxLocationCacheAgeSec,
      'prefetchEnabled': SeonGeolocationConfig.kDefaultPrefetchEnabled,
      'geolocationEnabled': SeonGeolocationConfig.kDefaultGeolocationEnabled,
    });
  });

  test('fingerprint calls work without an explicit initialize', () async {
    await plugin.setDnsTimeout(1000);

    expect(await plugin.getFingerprint('session'), 'fingerprint');
    await plugin.startBehaviourMonitoring();
    expect(await plugin.stopBehaviourMonitoring('session'), 'fingerprint');
    expect(methods(), [
      'setDnsTimeout',
      'getFingerprint',
      'startBehaviourMonitoring',
      'stopBehaviourMonitoring',
    ]);
  });

  test('setters work without an explicit initialize', () async {
    await plugin.setGeolocationEnabled(true);
    await plugin.setGeolocationTimeout(4000);
    await plugin.setDnsTimeout(1500);

    expect(methods(), [
      'setGeolocationEnabled',
      'setGeolocationTimeout',
      'setDnsTimeout',
    ]);
  });

  test('initializing then configuring then fingerprinting succeeds', () async {
    await plugin.initialize();
    await plugin.setGeolocationEnabled(true);
    await plugin.setDnsTimeout(2000);

    expect(await plugin.getFingerprint('session'), 'fingerprint');
    expect(methods(), [
      'initialize',
      'setGeolocationEnabled',
      'setDnsTimeout',
      'getFingerprint',
    ]);
  });

  test('configuring then initializing then fingerprinting succeeds', () async {
    await plugin.setGeolocationEnabled(true);
    await plugin.setDnsTimeout(2000);
    await plugin.initialize();

    expect(await plugin.getFingerprint('session'), 'fingerprint');
    expect(argumentsOf('getFingerprint'), {'sessionId': 'session'});
    expect(methods(), [
      'setGeolocationEnabled',
      'setDnsTimeout',
      'initialize',
      'getFingerprint',
    ]);
  });
}
