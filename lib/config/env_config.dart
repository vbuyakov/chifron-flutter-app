import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:chifron/utils/debug_utils.dart';

class EnvConfig {
  static String get _envFile {
    if (Platform.isAndroid) return '.env.android';
    if (Platform.isIOS) return '.env.ios';
    return ''; // Default fallback
  }

  // API Configuration
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ??
      (throw Exception('API_BASE_URL is required'));
  static String get apiKey =>
      dotenv.env['API_KEY'] ?? (throw Exception('API_KEY is required'));

  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Audio Configuration
  static String get audioCacheDir =>
      dotenv.env['AUDIO_CACHE_DIR'] ?? 'audio_cache';
  static String get audioFormat => dotenv.env['AUDIO_FORMAT'] ?? 'mp3';

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'Chifron';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  // Feature Flags
  static String get donateUrlKofi => dotenv.env['DONATE_URL_KOFI'] ?? '';
  static bool get enableDonateKofi =>
      (dotenv.env['FF_DONATE_KOFI']?.toLowerCase() == 'true') &&
      donateUrlKofi.isNotEmpty;

  /// Initialize the environment configuration
  static Future<void> load() async {
    try {
      // Load common .env file first
      await dotenv.load(fileName: '.env');
      debugLog('***** Loaded common environment configuration from: .env');

      // Then load platform-specific overrides (if they exist)
      
      if(_envFile != '') {
        await dotenv.load(fileName: _envFile, mergeWith: Map<String, String>.from(dotenv.env));
        debugLog('>>>>> Loaded platform-specific overrides from: $_envFile <<<<<');
      } 
    
    } catch (e) {
      // If common .env file doesn't exist, try platform-specific only
      try {
        await dotenv.load(fileName: _envFile);
        debugLog('Loaded environment configuration from: $_envFile');
      } catch (e2) {
        // If no .env files exist, use default values
        debugWarning('No .env files found, using default configuration values');
        debugLog(
            'Platform: ${Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : 'Unknown'}');
        debugLog(
            'API_BASE_URL and API_KEY are required in environment configuration');
      }
    }

    // Debug: Print all loaded environment variables
    debugLog('=== Environment Configuration Debug ===');
    debugLog(
        'Platform: ${Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : 'Unknown'}');
    debugLog('All env vars: ${dotenv.env}');
    debugLog('API_KEY: ${dotenv.env['API_KEY']}');
    debugLog('API_BASE_URL: ${dotenv.env['API_BASE_URL']}');
    debugLog('DEBUG_MODE: ${dotenv.env['DEBUG_MODE']}');
    debugLog('=====================================');
  }

  /// Get all environment variables as a map (useful for debugging)
  static Map<String, String> getAll() {
    return {
      'PLATFORM': Platform.isAndroid
          ? 'Android'
          : Platform.isIOS
              ? 'iOS'
              : 'Unknown',
      'ENV_FILE': _envFile,
      'API_BASE_URL': apiBaseUrl,
      'API_KEY': apiKey.isNotEmpty ? '***HIDDEN***' : 'NOT_SET',
      'API_TIMEOUT': apiTimeout.toString(),
      'AUDIO_CACHE_DIR': audioCacheDir,
      'AUDIO_FORMAT': audioFormat,
      'APP_NAME': appName,
      'APP_VERSION': appVersion,
      'DEBUG_MODE': debugMode.toString(),
      'FF_DONATE_KOFI': enableDonateKofi.toString(),
      'DONATE_URL_KOFI': donateUrlKofi,
    };
  }
}
