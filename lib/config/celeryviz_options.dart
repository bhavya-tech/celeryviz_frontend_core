import 'package:celeryviz_frontend_core/config/celeryviz_options_config.dart';

class CeleryvizOptions {
  static CeleryvizOptionsConfig? _config;
  static bool _initialized = false;

  /// Retrieves the strict singleton configuration.
  /// Throws a [StateError] if not yet initialized.
  static CeleryvizOptionsConfig get config {
    if (!_initialized || _config == null) {
      throw StateError(
          'CeleryvizOptions has not been initialized. It must be configured exactly once at startup.');
    }
    return _config!;
  }

  /// Evaluates whether the configuration has been initialized.
  static bool get isInitialized => _initialized;

  /// Initializes the singleton configuration.
  /// Throws a [StateError] if it has already been initialized (loud failure).
  static void initialize(CeleryvizOptionsConfig config) {
    if (_initialized) {
      throw StateError(
          'CeleryvizOptions has already been initialized. Runtime reconfiguration is NOT supported.');
    }
    _config = config;
    _initialized = true;
  }
}
