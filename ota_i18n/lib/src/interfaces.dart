abstract class OtaNetworkFetcher {
  /// Trả về chuỗi JSON từ API. Trả về null nếu lỗi.
  Future<String?> fetch(String url);
}

abstract class OtaLocalCache {
  Future<void> save(String data);
  Future<String?> read();
}