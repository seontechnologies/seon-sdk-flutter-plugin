# Flutter SEON SDK Plugin

The official Flutter plugin for integrating SEON's advanced fraud prevention and device fingerprinting capabilities into your Flutter applications. This plugin provides a unified interface to access the SEON SDK for both Android and iOS platforms.

To learn more about device fingerprinting please visit our [knowledge base](https://seon.io/resources/device-fingerprinting/).

>_The plugin depends on the closed-source SEON SDK binaries. While the Flutter plugin itself is open-source and distributed under the BSD 3-Clause License, the SEON SDK binaries remain proprietary and are subject to their own licensing terms. Please visit https://seon.io/resources/legal-and-security/legal/#terms-of-service for more details._

### Platform specific requirements
#### Android
- Android 5.0 or higher (API level 21)
- **INTERNET** permission
- _(optional)_ **READ_PHONE_STATE** permission for `is_on_call` and `device_cellular_id` (under API 28)
- _(optional)_ **ACCESS_WIFI_STATE** permission for `wifi_ssid` (under API 27)
- _(optional)_ **ACCESS_NETWORK_STATE** permission for `network_config` for WiFi configurations and **READ_PHONE_STATE** for cellular data configurations
- _(optional)_ **ACCESS_FINE_LOCATION** (starting from API 29) and ACCESS_COARSE_LOCATION (starting from API 27) permission for `wifi_mac_address`, `wifi_ssid`, `device_location`*
- _(optional)_ **ACCESS_BACKGROUND_LOCATION** (starting from API 29) permission for to get location updates even if the application is in the background
- _(optional)_ **com.google.android.providers.gsf.permission.READ_GSERVICES** for `gsf_id`

> __Note:__ If the optional permissions listed are not available the application, the values collected using those permissions will be ignored. We recommend using as much permission as possible based on your use-case to provide reliable device fingerprint.

> __*device_location:__ Please see the Geolocation Integration section for more info
#### iOS
- iOS 12.0 or higher
- _(optional)_ [Access WiFi Information entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info) for `wifi_mac_address` and `wifi_ssid`
- _(optional)_ [Core Location permission](https://developer.apple.com/documentation/corelocation/) for `device_location`*, `wifi_mac_address` and `wifi_ssid` (starting from iOS 13)

> __NOTE:__ If the listed permissions are not available for the application, the values collected using those permissions will be ignored. We recommend using as much permission as possible based on your use-case to provide reliable device fingerprint.

> __*device_location:__ Please see the Geolocation Integration section for more info
### Using the plugin

The SDK returns an encrypted, base64 encoded string. In order to receive the device details JSON a Fraud API request has to be made, and the result will be in the response.
The base64 encoded string has to be added in the session property in the Fraud API request. It isn’t possible to access or modify the payload on the clients.

```dart
final _seonSdkFlutterPlugin = SeonSdkFlutterPlugin();

try {
    String? fingerprint =
        await _seonSdkFlutterPlugin.getFingerprint("<UNIQUE_SESSION_ID>");
// Set fingerprint as the value for the session property of the Fraud API request.
} catch (e) {
    print("Error getting fingerprint: $e");
}
```


For more details about how to send the fingerprint to our API to receive the device details JSON visit our [Fraud API documentation](https://docs.seon.io/api-reference/fraud-api#ios-sdk).
### Geolocation Integration (Opt-in)

To enable SEON’s geolocation feature on your account please reach out the customer success team to enable the functionality on your Admin page and your Scoring Engine!

Note: Currently even if the integration has been done correctly there won't be a device_location field in the Fraud API response until the feature flag has been set by our customer success team.

**Enable or disable geolocation:**

```dart
// Prompt the user for the appropriate location permission(s)
// ...
// Must be explicitly enabled to turn on the Geolocation data collection
_seonSdkFlutterPlugin.setGeolocationEnabled(true);
// Optionally set the timeout in milliseconds for the location service
_seonSdkFlutterPlugin.setGeolocationTimeout(1500);
```


## Additional Information

For more details on SEON's capabilities and how to integrate our services, refer to the official [SEON Documentation](https://docs.seon.io) and the integration guide of the native SDKs:

- [Android SDK Integration Guide ](https://github.com/seontechnologies/seon-android-sdk-public)

- [iOS SDK Integration Guide](https://github.com/seontechnologies/seon-ios-sdk-public)