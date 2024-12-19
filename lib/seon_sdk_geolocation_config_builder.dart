import 'seon_sdk_geolocation_config.dart';

class SeonGeolocationConfigBuilder {
  int _locationServiceTimeoutMs = SeonGeolocationConfig.kDefaultLocationServiceTimeoutMs;
  int _maxLocationCacheAgeSec = SeonGeolocationConfig.kDefaultMaxLocationCacheAgeSec;
  bool _prefetchEnabled = SeonGeolocationConfig.kDefaultPrefetchEnabled;
  bool _geolocationEnabled = SeonGeolocationConfig.kDefaultGeolocationEnabled;

  SeonGeolocationConfigBuilder withLocationServiceTimeoutMs(int value) {
    _locationServiceTimeoutMs = value;
    return this;
  }

  SeonGeolocationConfigBuilder withMaxLocationCacheAgeSec(int value) {
    _maxLocationCacheAgeSec = value;
    return this;
  }

  SeonGeolocationConfigBuilder withPrefetchEnabled(bool value) {
    _prefetchEnabled = value;
    return this;
  }

  SeonGeolocationConfigBuilder withGeolocationEnabled(bool value) {
    _geolocationEnabled = value;
    return this;
  }

  SeonGeolocationConfig build() {
    return SeonGeolocationConfig(
      locationServiceTimeoutMs: _locationServiceTimeoutMs,
      maxLocationCacheAgeSec: _maxLocationCacheAgeSec,
      prefetchEnabled: _prefetchEnabled,
      geolocationEnabled: _geolocationEnabled,
    );
  }
}
