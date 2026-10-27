/// Abstract interface for fetching translation data from a remote source.
abstract class OtaNetworkFetcher {
  /// Fetches the translation JSON string from the given [url].
  ///
  /// Returns the JSON string if successful, or `null` if an error occurs.
  Future<String?> fetch(String url);
}

/// Abstract interface for local caching of translation data.
abstract class OtaLocalCache {
  /// Saves the translation [data] to local storage.
  Future<void> save(String data);

  /// Reads the translation data from local storage.
  ///
  /// Returns the JSON string if found, or `null` otherwise.
  Future<String?> read();
}
