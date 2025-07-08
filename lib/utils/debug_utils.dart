import 'package:flutter/foundation.dart';
import 'package:chifron/config/env_config.dart';

/// Debug print utility that only prints when debug mode is enabled
void debugLog(String message) {
  if (EnvConfig.debugMode) {
    debugPrint(message);
  }
}

/// Debug print utility with error level that only prints when debug mode is enabled
void debugError(String message) {
  if (EnvConfig.debugMode) {
    debugPrint('ERROR: $message');
  }
}

/// Debug print utility with warning level that only prints when debug mode is enabled
void debugWarning(String message) {
  if (EnvConfig.debugMode) {
    debugPrint('WARNING: $message');
  }
}
