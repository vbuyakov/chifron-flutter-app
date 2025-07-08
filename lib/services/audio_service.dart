import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:audioplayers/audioplayers.dart';
import 'package:chifron/config/env_config.dart';
import 'package:chifron/utils/debug_utils.dart';
import 'package:flutter/foundation.dart';

class AudioResponse {
  final int number;
  final String frenchText;
  final String audioUrl;

  AudioResponse({
    required this.number,
    required this.frenchText,
    required this.audioUrl,
  });

  factory AudioResponse.fromJson(Map<String, dynamic> json) {
    return AudioResponse(
      number: json['number'] as int,
      frenchText: json['french_text'] as String,
      audioUrl: json['audio_url'] as String,
    );
  }
}

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      debugLog('Audio player state changed: $state');
      // Do NOT call playAudio or playCurrentAudio here!
    });
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get isPlaying => _audioPlayer.state == PlayerState.playing;
  bool get isInitialized => _isInitialized;
  PlayerState get playerState => _audioPlayer.state;

  Future<Directory> get _audioCacheDir async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir =
          Directory(path.join(appDir.path, EnvConfig.audioCacheDir));
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      return cacheDir;
    } catch (e) {
      throw Exception('Failed to create audio cache directory: $e');
    }
  }

  /// Initialize audio player
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize audio player: $e');
    }
  }

  /// Play audio file by filename
  Future<void> playAudio(String fileName) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final audioPath = await getCachedAudioPath(fileName);
      if (audioPath == null) {
        throw Exception('Audio file not found: $fileName');
      }

      // Stop any currently playing audio
      await stopAudio();

      // Play the audio file
      await _audioPlayer.play(DeviceFileSource(audioPath));
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  /// Stop currently playing audio
  Future<void> stopAudio() async {
    try {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.stop();
      }
    } catch (e) {
      throw Exception('Failed to stop audio: $e');
    }
  }

  /// Pause currently playing audio
  Future<void> pauseAudio() async {
    try {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.pause();
      }
    } catch (e) {
      throw Exception('Failed to pause audio: $e');
    }
  }

  /// Resume paused audio
  Future<void> resumeAudio() async {
    try {
      if (_audioPlayer.state == PlayerState.paused) {
        await _audioPlayer.resume();
      }
    } catch (e) {
      throw Exception('Failed to resume audio: $e');
    }
  }

  /// Get number pronunciation from API
  Future<AudioResponse> getNumberPronunciation(int number) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${EnvConfig.apiKey}',
      };

      final response = await http
          .get(
            Uri.parse('${EnvConfig.apiBaseUrl}/api/audio/number/$number'),
            headers: headers,
          )
          .timeout(Duration(milliseconds: EnvConfig.apiTimeout));

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          return AudioResponse.fromJson(jsonData);
        } catch (e) {
          throw Exception('Failed to parse API response: $e');
        }
      } else {
        throw Exception(
            'API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      } else if (e is SocketException) {
        throw Exception('Connection failed: ${e.message}');
      } else if (e is TimeoutException) {
        throw Exception('Request timeout: ${e.message}');
      } else {
        throw Exception('Error getting pronunciation: $e');
      }
    }
  }

  /// Download and cache audio file
  Future<String> downloadAndCacheAudio(String audioUrl) async {
    try {
      // Extract filename from URL
      final fileName = path.basename(audioUrl);
      final cacheDir = await _audioCacheDir;
      final localPath = path.join(cacheDir.path, fileName);

      // Check if file already exists locally
      final localFile = File(localPath);
      if (await localFile.exists()) {
        return fileName; // Return filename if already cached
      }

      // Download the audio file
      final headers = <String, String>{
        'Authorization': 'Bearer ${EnvConfig.apiKey}',
      };

      final response = await http
          .get(
            Uri.parse('${EnvConfig.apiBaseUrl}$audioUrl'),
            headers: headers,
          )
          .timeout(Duration(milliseconds: EnvConfig.apiTimeout));

      if (response.statusCode == 200) {
        try {
          // Save to local cache
          await localFile.writeAsBytes(response.bodyBytes);
          return fileName;
        } catch (e) {
          throw Exception('Failed to save audio file: $e');
        }
      } else {
        throw Exception('Failed to download audio: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error downloading audio: ${e.message}');
      } else if (e is SocketException) {
        throw Exception('Connection failed downloading audio: ${e.message}');
      } else if (e is TimeoutException) {
        throw Exception('Download timeout: ${e.message}');
      } else {
        throw Exception('Error downloading audio: $e');
      }
    }
  }

  /// Get cached audio file path
  Future<String?> getCachedAudioPath(String fileName) async {
    try {
      final cacheDir = await _audioCacheDir;
      final localPath = path.join(cacheDir.path, fileName);
      final localFile = File(localPath);

      if (await localFile.exists()) {
        return localPath;
      }
      return null;
    } catch (e) {
      // Return null instead of throwing for non-critical operations
      return null;
    }
  }

  /// Check if audio file is cached locally
  Future<bool> isAudioCached(String fileName) async {
    try {
      final cacheDir = await _audioCacheDir;
      final localPath = path.join(cacheDir.path, fileName);
      final localFile = File(localPath);
      return await localFile.exists();
    } catch (e) {
      // Return false instead of throwing for non-critical operations
      return false;
    }
  }

  /// Clear all cached audio files
  Future<void> clearAudioCache() async {
    try {
      final cacheDir = await _audioCacheDir;
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      throw Exception('Failed to clear audio cache: $e');
    }
  }

  /// Get audio file info for a number (pronunciation + cached filename)
  Future<Map<String, dynamic>> getAudioInfo(int number) async {
    try {
      // Get pronunciation from API
      final audioResponse = await getNumberPronunciation(number);

      // Check if audio is already cached
      final fileName = path.basename(audioResponse.audioUrl);
      final isCached = await isAudioCached(fileName);

      if (!isCached) {
        try {
          // Download and cache the audio file
          await downloadAndCacheAudio(audioResponse.audioUrl);
        } catch (e) {
          // If download fails, still return the info but mark as not cached
          return {
            'number': audioResponse.number,
            'frenchText': audioResponse.frenchText,
            'audioFileName': fileName,
            'isCached': false,
            'error': 'Failed to cache audio: $e',
          };
        }
      }

      return {
        'number': audioResponse.number,
        'frenchText': audioResponse.frenchText,
        'audioFileName': fileName,
        'isCached': true,
      };
    } catch (e) {
      throw Exception('Error getting audio info: $e');
    }
  }

  /// Dispose audio player resources
  Future<void> dispose() async {
    try {
      await stopAudio();
      await _audioPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      // Ignore disposal errors
    }
  }
}
