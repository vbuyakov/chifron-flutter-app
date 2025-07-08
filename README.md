# Chifron - French Numbers Learning App

A Flutter application designed to help users learn French numbers through interactive gameplay. The app features audio pronunciation, statistics tracking, and a modern user interface.

## Features

- 🎯 **Interactive Number Learning**: Practice French numbers with audio pronunciation
- 🔊 **Audio Support**: Hear correct pronunciation using AI generated text-to-speech
- 📊 **Statistics Tracking**: Monitor your learning progress 
- 🌍 **Multi-language Support**: Available in English, Ukrainian, Portugal, Spanish, Deutch and Italian
- 🎮 **Game Mode**: Engaging number guessing game with replay functionality
- 💝 **Donation Support**: Support the project via Ko-fi

## API Backend

This app connects to the [Chifron Voice API](https://github.com/vbuyakov/chifron-site-api) for:
- Number-to-French-text conversion
- Audio file generation using Google Text-to-Speech (gTTS)
- Audio file caching for improved performance

The API provides a production-ready REST service with authentication, rate limiting, and Docker support.

## Donation

If you find this app helpful, consider supporting the project:

[![ko-fi](https://storage.ko-fi.com/cdn/kofi6.png?v=6)](https://ko-fi.com/X8X61HDXIO)

Your support helps maintain and improve the app!

## Environment Configuration Setup

This Flutter app uses environment variables to manage configuration settings like API keys, URLs, and feature flags with **platform-specific support**.

### Setup Instructions

#### 1. Create Platform-Specific Environment Files

The app automatically detects the platform and loads the appropriate configuration file:

- **`.env.android`** - Android-specific configuration
- **`.env.ios`** - iOS-specific configuration  
- **`.env`** - Default/fallback configuration

Create the appropriate `.env` file(s) in the root directory of your project:

```env
# API Configuration
API_BASE_URL=https://api.example.com
API_KEY=your_actual_api_key_here
API_TIMEOUT=30000

# Audio Configuration
AUDIO_CACHE_DIR=audio_cache
AUDIO_FORMAT=mp3

# App Configuration
APP_NAME=Chifron
APP_VERSION=1.0.0
DEBUG_MODE=true

# Donation Configuration
FF_DONATE_KOFI=true
DONATE_URL_KOFI=https://ko-fi.com/your_username
```

#### 2. Platform-Specific Configuration Examples

##### For Android (`.env.android`):
```env
# Platform-specific overrides for Android
API_BASE_URL=https://api.example.com
AUDIO_CACHE_DIR=android_audio_cache
FF_DONATE_KOFI=true
DONATE_URL_KOFI=https://ko-fi.com/your_username
```

##### For iOS (`.env.ios`):
```env
# Platform-specific overrides for iOS
API_BASE_URL=https://api.example.com
AUDIO_CACHE_DIR=ios_audio_cache
FF_DONATE_KOFI=true
DONATE_URL_KOFI=https://ko-fi.com/your_username
```

#### 3. Add Environment Files to `.gitignore`

Make sure your environment files are not committed to version control by adding them to `.gitignore`:

```gitignore
# Environment files
.env
.env.android
.env.ios
```

#### 4. Install Dependencies

Run the following command to install the required dependencies:

```bash
flutter pub get
```

### Usage

#### Accessing Environment Variables

Environment variables are accessed through the `EnvConfig` class:

```dart
import 'package:your_app/config/env_config.dart';

// API Configuration
String apiUrl = EnvConfig.apiBaseUrl;
String apiKey = EnvConfig.apiKey;
int timeout = EnvConfig.apiTimeout;

// Audio Configuration
String cacheDir = EnvConfig.audioCacheDir;
String audioFormat = EnvConfig.audioFormat;

// App Configuration
String appName = EnvConfig.appName;
bool debugMode = EnvConfig.debugMode;

// Donation Configuration
bool donateKofiEnabled = EnvConfig.enableDonateKofi;
String donateUrl = EnvConfig.donateUrlKofi;
```

#### Environment-Specific Configuration

You can create different `.env` files for different environments:

- `.env` - Default/development environment
- `.env.production` - Production environment
- `.env.staging` - Staging environment

To use a specific environment file, modify the `_envFile` constant in `lib/config/env_config.dart`:

```dart
static const String _envFile = '.env.production'; // For production
```

### Security Best Practices

1. **Never commit API keys**: Always keep your `.env` file in `.gitignore`
2. **Use different keys for different environments**: Use separate API keys for development, staging, and production
3. **Validate environment variables**: The `EnvConfig` class provides default values for missing variables
4. **Hide sensitive data in logs**: The `getAll()` method hides API keys in debug output

### Debugging

To see all current environment variable values (with sensitive data hidden):

```dart
Map<String, String> allConfig = EnvConfig.getAll();
print(allConfig);
```

This will output something like:
```
{
  API_BASE_URL: http://localhost:5001,
  API_KEY: ***HIDDEN***,
  API_TIMEOUT: 30000,
  ...
}
```

## Required Configuration

**⚠️ IMPORTANT**: The following configuration is **REQUIRED** for the app to function:

- `API_BASE_URL` - Must be defined in your environment file(s)
- `API_KEY` - Must be defined in your environment file(s)

Without these required values, the app will throw an exception and fail to start.

## Available Configuration Options

### API Configuration
- `API_BASE_URL`: **REQUIRED** - Base URL for API requests (no default, must be defined)
- `API_KEY`: **REQUIRED** - API key for authentication (no default, must be defined)
- `API_TIMEOUT`: Request timeout in milliseconds (default: 30000)

### Audio Configuration
- `AUDIO_CACHE_DIR`: Directory name for cached audio files (default: audio_cache)
- `AUDIO_FORMAT`: Audio file format (default: mp3)

### App Configuration
- `APP_NAME`: Application name (default: Chifron)
- `APP_VERSION`: Application version (default: 1.0.0)
- `DEBUG_MODE`: Enable debug mode (default: false)

### Donation Configuration
- `FF_DONATE_KOFI`: Enable Ko-fi donation button (default: true)
- `DONATE_URL_KOFI`: Ko-fi donation URL (default: https://ko-fi.com/your_username)

## Getting Started

1. Clone the repository
2. Set up your environment configuration (see above)
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## License

This project is licensed under the MIT License.
