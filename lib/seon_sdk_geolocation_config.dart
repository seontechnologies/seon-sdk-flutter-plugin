class SeonGeolocationConfig {
  // Default constants
  static const int kDefaultLocationServiceTimeoutMs = 3000;
  static const int kDefaultMaxLocationCacheAgeSec = 600;
  static const bool kDefaultPrefetchEnabled = true;
  static const bool kDefaultGeolocationEnabled = false;

  // Private fields
  int _locationServiceTimeoutMs;
  int _maxLocationCacheAgeSec;
  bool _prefetchEnabled;
  bool _geolocationEnabled;

  // Constructor with optional parameters and default values
  SeonGeolocationConfig({
    int locationServiceTimeoutMs = kDefaultLocationServiceTimeoutMs,
    int maxLocationCacheAgeSec = kDefaultMaxLocationCacheAgeSec,
    bool prefetchEnabled = kDefaultPrefetchEnabled,
    bool geolocationEnabled = kDefaultGeolocationEnabled,
  })  : _locationServiceTimeoutMs = locationServiceTimeoutMs,
        _maxLocationCacheAgeSec = maxLocationCacheAgeSec,
        _prefetchEnabled = prefetchEnabled,
        _geolocationEnabled = geolocationEnabled;

  // Getters and setters

  /// Get the Geolocation service timeout in milliseconds.
  int get geolocationServiceTimeoutMs => _locationServiceTimeoutMs;

  /// Set the Geolocation service timeout in milliseconds.
  set geolocationServiceTimeoutMs(int value) {
    _locationServiceTimeoutMs = value;
  }

  /// Get the max Geolocation cache age in seconds.
  int get maxGeoLocationCacheAgeSec => _maxLocationCacheAgeSec;

  /// Set the max Geolocation cache age in seconds.
  set maxGeoLocationCacheAgeSec(int value) {
    _maxLocationCacheAgeSec = value;
  }

  /// Get whether Location prefetching is enabled or not.
  bool get prefetchEnabled => _prefetchEnabled;

  /// Set Geolocation prefetching.
  set prefetchEnabled(bool value) {
    _prefetchEnabled = value;
  }

  /// Get whether Geolocation is enabled or not.
  bool get geolocationEnabled => _geolocationEnabled;

  /// Set Geolocation permit.
  set geolocationEnabled(bool value) {
    _geolocationEnabled = value;
  }
  /// Converts all settable fields to a Map<String, dynamic>.
  Map<String, Object> toMap() {
    return {
      'geolocationServiceTimeoutMs': _locationServiceTimeoutMs,
      'maxGeoLocationCacheAgeSec': _maxLocationCacheAgeSec,
      'prefetchEnabled': _prefetchEnabled,
      'geolocationEnabled': _geolocationEnabled,
    };
  }
}
