import 'package:test/test.dart';
import 'package:spool_coder_app/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('should create default local configuration', () {
      const config = AppConfig.defaultLocal;
      
      expect(config.isBackendEnabled, false);
      expect(config.canWorkOffline, true);
      expect(config.enableAutoSync, true);
      expect(config.syncInterval, const Duration(minutes: 15));
    });

    test('should create backend-enabled configuration', () {
      final config = AppConfig.withBackend(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        syncInterval: const Duration(minutes: 5),
      );
      
      expect(config.isBackendEnabled, true);
      expect(config.backend.baseUrl, 'https://api.example.com');
      expect(config.backend.apiKey, 'test-key');
      expect(config.syncInterval, const Duration(minutes: 5));
    });

    test('should validate backend configuration', () {
      const validConfig = BackendConfig.enabled(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
      
      expect(validConfig.isValid, true);
      expect(validConfig.validate(), null);
    });

    test('should detect invalid backend configuration', () {
      const invalidConfig = BackendConfig.enabled(
        baseUrl: 'invalid-url',
      );
      
      expect(invalidConfig.isValid, false);
      expect(invalidConfig.validate(), isNotNull);
    });

    test('should generate correct API endpoints', () {
      const config = BackendConfig.enabled(
        baseUrl: 'https://api.example.com',
        apiVersion: 'v2',
      );
      
      final endpoint = config.getEndpoint('/spools');
      expect(endpoint, 'https://api.example.com/api/v2/spools');
    });

    test('should generate correct headers', () {
      const config = BackendConfig.enabled(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
        headers: {'Custom-Header': 'value'},
      );
      
      final headers = config.getHeaders();
      expect(headers['Authorization'], 'Bearer test-key');
      expect(headers['Content-Type'], 'application/json');
      expect(headers['Custom-Header'], 'value');
    });
  });

  group('ConfigFactory', () {
    test('should create development configuration', () {
      final config = ConfigFactory.forEnvironment(Environment.development);
      
      expect(config.isBackendEnabled, false);
      expect(config.enableOfflineMode, true);
      expect(config.enableAutoSync, false);
    });

    test('should create production configuration', () {
      final config = ConfigFactory.forEnvironment(Environment.production);
      
      expect(config.isBackendEnabled, true);
      expect(config.backend.baseUrl, 'https://api.spoolcoder.com');
      expect(config.enableAutoSync, true);
    });
  });
}