import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:seon_sdk_flutter_plugin/seon_sdk_flutter_plugin.dart';

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
      _seonSdkFlutterPlugin.setGeolocationEnabled(true);
      _seonSdkFlutterPlugin.setGeolocationTimeout(500);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Seon SDK Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      'Fingerprint: $_fingerprint\n',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
          ),
        ),
      ),
    );
  }
}
