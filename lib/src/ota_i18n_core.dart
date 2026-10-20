import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'interfaces.dart';

class OtaI18n {
  static OtaI18n? _instance;
  static OtaI18n get instance => _instance ?? (throw Exception('Call OtaI18n.init() first!'));

  final OtaNetworkFetcher? fetcher;
  final OtaLocalCache? cache;

  Map<String, String> _flatTranslations = {};

  OtaI18n._({this.fetcher, this.cache});

  @visibleForTesting
  OtaI18n.internal({this.fetcher, this.cache});

  static Future<void> init({
    required String defaultJsonAssetPath,
    String? apiUrl,
    OtaNetworkFetcher? fetcher,
    OtaLocalCache? cache,
  }) async {
    _instance = OtaI18n._(fetcher: fetcher, cache: cache);
    await _instance!._loadData(defaultJsonAssetPath, apiUrl);
  }

  Future<void> _loadData(String assetPath, String? apiUrl) async {
    String? jsonString;

    if (apiUrl != null && fetcher != null) {
      try {
        jsonString = await fetcher!.fetch(apiUrl);
        if (jsonString != null && cache != null) {
          await cache!.save(jsonString);
        }
      } catch (e) {
        debugPrint('[OtaI18n] Network error: $e');
      }
    }

    if (jsonString == null && cache != null) {
      try {
        jsonString = await cache!.read();
      } catch (e) {
        debugPrint('[OtaI18n] Cache error: $e');
      }
    }

    if (jsonString == null) {
      try {
        jsonString = await rootBundle.loadString(assetPath);
      } catch (e) {
        debugPrint('[OtaI18n] Asset load error: $e');
        jsonString = '{}';
      }
    }

    final Map<String, dynamic> rawMap = jsonDecode(jsonString);
    _flatTranslations = flattenMap(rawMap);
  }

  String getText(String path, String fallback) {
    return _flatTranslations[path] ?? fallback;
  }

  @visibleForTesting
  void setFlatTranslations(Map<String, dynamic> rawMap) {
    _flatTranslations = flattenMap(rawMap);
  }

  static Map<String, String> flattenMap(Map<String, dynamic> map, [String prefix = '']) {
    final Map<String, String> result = {};
    map.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        result.addAll(flattenMap(value, newKey));
      } else {
        result[newKey] = value.toString();
      }
    });
    return result;
  }
}
