## Upcoming version
- Add Swift Package Manager support
## 1.2.4
- Supports Android SDK version: `6.8.2`. For the changelog visit: https://github.com/seontechnologies/seon-android-sdk-public#682
## 1.2.3
- Supports iOS SDK version: `5.6.3` For the changelog visit: https://github.com/seontechnologies/seon-ios-sdk-public#563
## 1.2.2
- Lowered `sourceCompatibility` and `targetCompatibility` to Java version 1.8 on Android
- Removed the following permissions from our `AndroidManifest.xml`:
    > __Note:__ If you depend any of the optional features connected to these permissions, from this version onwards you need to add them to your `AndroidManifest.xml` manually

    > Please, read carefully what features are connected to these permissions in `README.md` or in our Android SDK public documentation's [Requirements section](https://github.com/seontechnologies/seon-android-sdk-public?tab=readme-ov-file#requirements)
    - `android.permission.ACCESS_FINE_LOCATION`
    - `android.permission.ACCESS_COARSE_LOCATION`
    - `android.permission.READ_PHONE_STATE`
    - `android.permission.READ_PHONE_NUMBERS`
- Supports Android SDK version: `6.8.1`. For the changelog visit: https://github.com/seontechnologies/seon-android-sdk-public#681
## 1.2.1
- ⚠️ **IMPORTANT! This version includes necessary fixes to be compliant and compatible with iOS 26!** ⚠️
- Supports iOS SDK version: `5.6.2` For the changelog visit: https://github.com/seontechnologies/seon-ios-sdk-public#562
## 1.2.0
- Added 16 KB page size support to ensure Google Play compatibility beyond November 1st, 2025. Please carefully read the [related documentation](https://github.com/seontechnologies/seon-android-sdk-public?tab=readme-ov-file#16-kb-page-size-compatibility-on-google-play)!
- Supports Android SDK version: `6.8.0`. For the changelog visit: https://github.com/seontechnologies/seon-android-sdk-public#680
- Supports iOS SDK version: `5.6.1` For the changelog visit: https://github.com/seontechnologies/seon-ios-sdk-public#561
- Added fixes and improvements
## 1.1.0
- Introduced Geolocation config object
- Introduced Behavioural monitoring support
- Supports Android SDK version: `6.6.0`. For the changelog visit: https://github.com/seontechnologies/seon-android-sdk-public#660
- Supports iOS SDK version: `5.5.1` For the changelog visit: https://github.com/seontechnologies/seon-ios-sdk-public#551
- Added fixes and improvements
## 1.0.1
- Fixed error propagation
## 1.0.0
- Initial release
- Supports Android SDK version: `6.4.1`. For the changelog visit: https://github.com/seontechnologies/seon-android-sdk-public#641
- Supports iOS SDK version: `5.3.0` For the changelog visit: https://github.com/seontechnologies/seon-ios-sdk-public#530
