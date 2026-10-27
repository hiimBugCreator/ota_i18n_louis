import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'interfaces.dart';

/// The core engine for Over-The-Air (OTA) internationalization.
///
/// This class manages the lifecycle of translations, including fetching from
/// remote sources, caching locally, and providing O(1) lookup for strings.
class OtaI18n {
  static OtaI18n? _instance;

  /// The singleton instance of [OtaI18n].
  ///
  /// Throws an [Exception] if [init] has not been called yet.
  static OtaI18n get instance =>
      _instance ?? (throw Exception('Call OtaI18n.init() first!'));

  /// The network fetcher used to retrieve remote translations.
  final OtaNetworkFetcher? fetcher;

  /// The local cache used to store and retrieve translations.
  final OtaLocalCache? cache;

  Map<String, String> _flatTranslations = {};

  OtaI18n._({this.fetcher, this.cache});

  /// Internal constructor for testing purposes.
  @visibleForTesting
  OtaI18n.internal({this.fetcher, this.cache});

  /// Initializes the [OtaI18n] engine.
  ///
  /// [defaultJsonAssetPath] is the path to the fallback JSON file in assets.
  /// [apiUrl] is the optional remote URL to fetch updates from.
  /// [fetcher] and [cache] can be injected for custom networking and storage.
  static Future<void> init({
    required String defaultJsonAssetPath,
    String? apiUrl,
    OtaNetworkFetcher? fetcher,
    OtaLocalCache? cache,
  }) async {
    final instance = OtaI18n._(fetcher: fetcher, cache: cache);
    _instance = instance;
    await instance._loadData(defaultJsonAssetPath, apiUrl);
  }

  Future<void> _loadData(String assetPath, String? apiUrl) async {
    String? jsonString;

    // 1. Try Network
    final currentFetcher = fetcher;
    if (apiUrl != null && currentFetcher != null) {
      try {
        jsonString = await currentFetcher.fetch(apiUrl);
        final currentCache = cache;
        if (jsonString != null && currentCache != null) {
          await currentCache.save(jsonString);
        }
      } catch (e) {
        debugPrint('[OtaI18n] Network error: $e');
      }
    }

    // 2. Try Cache
    final currentCache = cache;
    if (jsonString == null && currentCache != null) {
      try {
        jsonString = await currentCache.read();
      } catch (e) {
        debugPrint('[OtaI18n] Cache error: $e');
      }
    }

    // 3. Fallback to Assets
    if (jsonString == null) {
      try {
        jsonString = await rootBundle.loadString(assetPath);
      } catch (e) {
        debugPrint('[OtaI18n] Asset load error: $e');
        jsonString = '{}';
      }
    }

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    _flatTranslations = flattenMap(data);
  }

  /// Retrieves a translated string for the given [path].
  ///
  /// Returns [fallback] if the path is not found.
  String getText(String path, String fallback) {
    return _flatTranslations[path] ?? fallback;
  }

  /// Manually sets translations for testing purposes.
  @visibleForTesting
  void setFlatTranslations(Map<String, dynamic> rawMap) {
    _flatTranslations = flattenMap(rawMap);
  }

  /// Flattens a nested [map] into a single-level map with dot-separated keys.
  static Map<String, String> flattenMap(Map<String, dynamic> map,
      [String prefix = '']) {
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
