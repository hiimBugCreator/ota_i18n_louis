import 'package:flutter_test/flutter_test.dart';
import 'package:ota_i18n_louis/ota_i18n_louis.dart';

class MockFetcher extends OtaNetworkFetcher {
  final String? response;
  MockFetcher(this.response);

  @override
  Future<String?> fetch(String url) async => response;
}

class MockCache extends OtaLocalCache {
  String? data;
  @override
  Future<String?> read() async => data;
  @override
  Future<void> save(String data) async => this.data = data;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OtaI18n Core Tests', () {
    test('Flatten map logic', () {
      final ota = OtaI18n.internal();
      ota.setFlatTranslations({
        'core': {
          'title': 'Hello',
          'nested': {'key': 'value'}
        },
        'auth': 'Login'
      });

      expect(ota.getText('core.title', ''), 'Hello');
      expect(ota.getText('core.nested.key', ''), 'value');
      expect(ota.getText('auth', ''), 'Login');
    });

    test('getText returns fallback when key missing', () {
      final ota = OtaI18n.internal();
      ota.setFlatTranslations({'a': 'b'});
      expect(ota.getText('missing', 'fallback'), 'fallback');
    });
  });

  group('OTA Logic Tests', () {
    test('Initialization with Network Fetcher', () async {
      final fetcher = MockFetcher('{"title": "Remote"}');
      final cache = MockCache();

      // We use a dummy asset path. In real flutter test, rootBundle.loadString might throw
      // if not properly mocked, but here we expect it to try and fail/fallback if apiUrl works.
      await OtaI18n.init(
        defaultJsonAssetPath: 'invalid_path',
        apiUrl: 'https://example.com/en.json',
        fetcher: fetcher,
        cache: cache,
      );

      expect(OtaI18n.instance.getText('title', ''), 'Remote');
      expect(cache.data, '{"title": "Remote"}');
    });

    test('Initialization with Cache when Network fails', () async {
      final fetcher = MockFetcher(null); // Network fails
      final cache = MockCache()..data = '{"title": "Cached"}';

      await OtaI18n.init(
        defaultJsonAssetPath: 'invalid_path',
        apiUrl: 'https://example.com/en.json',
        fetcher: fetcher,
        cache: cache,
      );

      expect(OtaI18n.instance.getText('title', ''), 'Cached');
    });
  });
}
