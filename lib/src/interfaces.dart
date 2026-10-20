abstract class OtaNetworkFetcher {
  /// Returns JSON string from API. Returns null on error.
  Future<String?> fetch(String url);
}

abstract class OtaLocalCache {
  /// Saves the translation data locally.
  Future<void> save(String data);

  /// Reads the translation data from local storage.
  Future<String?> read();
}
