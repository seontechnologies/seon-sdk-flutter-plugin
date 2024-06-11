// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getFingerprint test', (WidgetTester tester) async {
    final SeonSdkFlutterPlugin plugin = SeonSdkFlutterPlugin();
    final String? fingerprint =
        await plugin.getFingerprint("1111-1111-1111-aaa");
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(fingerprint?.isNotEmpty, true);
  });
}
