/// Application configuration for optional backend integration
/// Part of the Core Layer: manages app-wide configuration settings
class AppConfig {
  final BackendConfig backend;
  final bool enableOfflineMode;
  final Duration syncInterval;
  final bool enableAutoSync;
  final int maxRetryAttempts;
  final Duration retryDelay;

  const AppConfig({
    required this.backend,
    this.enableOfflineMode = true,
    this.syncInterval = const Duration(minutes: 15),
    this.enableAutoSync = true,
    this.maxRetryAttempts = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  /// Default configuration with backend disabled
  static const AppConfig defaultLocal = AppConfig(
    backend: BackendConfig.disabled(),
  );

  /// Configuration with backend enabled
  factory AppConfig.withBackend({
    required String baseUrl,
    String? apiKey,
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 30),
    bool enableOfflineMode = true,
    Duration syncInterval = const Duration(minutes: 15),
    bool enableAutoSync = true,
  }) {
    return AppConfig(
      backend: BackendConfig.enabled(
        baseUrl: baseUrl,
        apiKey: apiKey,
        headers: headers,
        timeout: timeout,
      ),
      enableOfflineMode: enableOfflineMode,
      syncInterval: syncInterval,
      enableAutoSync: enableAutoSync,
    );
  }

  /// Whether backend integration is enabled
  bool get isBackendEnabled => backend.isEnabled;

  /// Whether the app can work offline
  bool get canWorkOffline => enableOfflineMode;

  /// Copy configuration with updated values
  AppConfig copyWith({
    BackendConfig? backend,
    bool? enableOfflineMode,
    Duration? syncInterval,
    bool? enableAutoSync,
    int? maxRetryAttempts,
    Duration? retryDelay,
  }) {
    return AppConfig(
      backend: backend ?? this.backend,
      enableOfflineMode: enableOfflineMode ?? this.enableOfflineMode,
      syncInterval: syncInterval ?? this.syncInterval,
      enableAutoSync: enableAutoSync ?? this.enableAutoSync,
      maxRetryAttempts: maxRetryAttempts ?? this.maxRetryAttempts,
      retryDelay: retryDelay ?? this.retryDelay,
    );
  }
}

/// Backend-specific configuration
class BackendConfig {
  final bool isEnabled;
  final String? baseUrl;
  final String? apiKey;
  final Map<String, String> headers;
  final Duration timeout;
  final String apiVersion;

  const BackendConfig._({
    required this.isEnabled,
    this.baseUrl,
    this.apiKey,
    this.headers = const {},
    this.timeout = const Duration(seconds: 30),
    this.apiVersion = 'v1',
  });

  /// Disabled backend configuration
  const BackendConfig.disabled() : this._(isEnabled: false);

  /// Enabled backend configuration
  const BackendConfig.enabled({
    required String baseUrl,
    String? apiKey,
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 30),
    String apiVersion = 'v1',
  }) : this._(
          isEnabled: true,
          baseUrl: baseUrl,
          apiKey: apiKey,
          headers: headers,
          timeout: timeout,
          apiVersion: apiVersion,
        );

  /// Get API endpoint URL
  String? getEndpoint(String path) {
    if (!isEnabled || baseUrl == null) return null;
    final cleanBaseUrl = baseUrl!.endsWith('/') ? baseUrl!.substring(0, baseUrl!.length - 1) : baseUrl!;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBaseUrl/api/$apiVersion$cleanPath';
  }

  /// Get headers for API requests
  Map<String, String> getHeaders({Map<String, String> additional = const {}}) {
    final allHeaders = Map<String, String>.from(headers);
    
    // Add API key if available
    if (apiKey != null) {
      allHeaders['Authorization'] = 'Bearer $apiKey';
    }
    
    // Add content type
    allHeaders['Content-Type'] = 'application/json';
    allHeaders['Accept'] = 'application/json';
    
    // Add additional headers
    allHeaders.addAll(additional);
    
    return allHeaders;
  }

  /// Validate backend configuration
  String? validate() {
    if (!isEnabled) return null;
    
    if (baseUrl == null || baseUrl!.isEmpty) {
      return 'Base URL is required when backend is enabled';
    }
    
    try {
      Uri.parse(baseUrl!);
    } catch (e) {
      return 'Invalid base URL format: $baseUrl';
    }
    
    if (timeout.inMilliseconds <= 0) {
      return 'Timeout must be positive';
    }
    
    return null;
  }

  /// Whether the configuration is valid
  bool get isValid => validate() == null;
}

/// Environment-specific configurations
enum Environment {
  development,
  staging,
  production,
}

/// Configuration factory for different environments
class ConfigFactory {
  /// Get configuration for specific environment
  static AppConfig forEnvironment(Environment env) {
    switch (env) {
      case Environment.development:
        return const AppConfig(
          backend: BackendConfig.disabled(), // Start with local-only in development
          enableOfflineMode: true,
          syncInterval: Duration(minutes: 1), // Frequent sync for testing
          enableAutoSync: false, // Manual sync for development
        );
      
      case Environment.staging:
        return AppConfig.withBackend(
          baseUrl: 'https://staging-api.spoolcoder.com',
          syncInterval: const Duration(minutes: 5),
          enableAutoSync: true,
        );
      
      case Environment.production:
        return AppConfig.withBackend(
          baseUrl: 'https://api.spoolcoder.com',
          syncInterval: const Duration(minutes: 15),
          enableAutoSync: true,
        );
    }
  }

  /// Load configuration from environment variables
  static AppConfig fromEnvironment() {
    final backendUrl = const String.fromEnvironment('BACKEND_URL');
    final apiKey = const String.fromEnvironment('API_KEY');
    final enableBackend = const bool.fromEnvironment('ENABLE_BACKEND', defaultValue: false);
    
    if (enableBackend && backendUrl.isNotEmpty) {
      return AppConfig.withBackend(
        baseUrl: backendUrl,
        apiKey: apiKey.isNotEmpty ? apiKey : null,
      );
    }
    
    return AppConfig.defaultLocal;
  }
}