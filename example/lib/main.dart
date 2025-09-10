import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_geolocation_config.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_geolocation_config_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fingerprint = 'Unknown';
  final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();

  @override
  void initState() {
    super.initState();
    try {
      final geoConfig = SeonGeolocationConfigBuilder().withGeolocationEnabled(true).withLocationServiceTimeoutMs(5000).withPrefetchEnabled(true).withMaxLocationCacheAgeSec(10).build();
      _seonSdkFlutterPlugin.setGeolocationConfig(geoConfig);
    } catch (e) {
      print('$e');
    }
  }

  // Method to get fingerprint
  Future<void> getFingerprint() async {
    String fingerprint;
    try {
      fingerprint = await _seonSdkFlutterPlugin
              .getFingerprint("flutter-demo-session-id-1111") ??
          'Error getting fingerprint';
    } catch (e) {
      fingerprint = 'Failed to get fingerprint $e';
    }

    if (!mounted) return;
    print(fingerprint);
    setState(() {
      _fingerprint = fingerprint;
    });
  }

    Future<void> stopBehaviourMonitoring() async {
    String fingerprint;
    try {
      fingerprint = await _seonSdkFlutterPlugin
              .stopBehaviourMonitoring("flutter-behaviour-demo-session-id-2222") ??
          'Error getting fingerprint';
    } catch (e) {
      fingerprint = 'Failed to get fingerprint $e';
    }

    if (!mounted) return;
    print(fingerprint);
    setState(() {
      _fingerprint = fingerprint;
    });
  }

  // Method to copy text to clipboard
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
  Future<void> startBehaviourMonitoring() async {
    String fingerprint = "";
    print('Behaviour started');
    try {
      _seonSdkFlutterPlugin.startBehaviourMonitoring();
    } catch (e) {
      fingerprint = 'Failed to start behaviour $e';
      if (mounted) {
        setState(() {
          _fingerprint = fingerprint;
        });
      }
    }
  }

 @override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Seon SDK Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.5, // Limit to 50% of screen height
                child: SingleChildScrollView(
                  child: SelectableText(
                    'Fingerprint: $_fingerprint\n',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: getFingerprint,
                    child: const Text('Get Fingerprint'),
                  ),
                  ElevatedButton(
                    onPressed: () => copyToClipboard(_fingerprint),
                    child: const Text('Copy to Clipboard'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: startBehaviourMonitoring,
                    child: const Text('Start behaviour'),
                  ),
                  ElevatedButton(
                    onPressed: stopBehaviourMonitoring,
                    child: const Text('Stop behaviour'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
