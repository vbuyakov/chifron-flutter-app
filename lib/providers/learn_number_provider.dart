import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chifron/services/audio_service.dart';
import 'package:chifron/utils/debug_utils.dart';
import 'package:chifron/providers/number_range_settings.dart';

class LearnNumberProvider extends ChangeNotifier {
  int? _currentNumber;
  String? _currentAudioFileName;
  String? _currentFrenchText;
  bool _isLoading = false;
  String? _error;

  int? get currentNumber => _currentNumber;
  String? get currentAudioFileName => _currentAudioFileName;
  String? get currentFrenchText => _currentFrenchText;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final AudioService _audioService = AudioService();

  LearnNumberProvider() {
    // Listen to audio player state changes and notify listeners for UI updates
    AudioService().audioPlayer.onPlayerStateChanged.listen((_) {
      notifyListeners();
    });
  }

  Future<void> generateRandomNumber() async {
    try {
      _setLoading(true);
      _clearError();

      final rangeSettings = NumberRangeSettings();
      await rangeSettings.load();
      final min = rangeSettings.minValue;
      final max = rangeSettings.maxValue;
      final rand = Random();
      final newNumber = min + rand.nextInt(max - min + 1);

      debugLog('Generated number: $newNumber');

      // Get audio info for the number
      final audioInfo = await _audioService.getAudioInfo(newNumber);

      _currentNumber = newNumber;
      _currentAudioFileName = audioInfo['audioFileName'] as String?;
      _currentFrenchText = audioInfo['frenchText'] as String?;

      // Check if there was an error caching the audio
      if (audioInfo['error'] != null) {
        debugWarning('${audioInfo['error']}');
        // Still continue with the number, but audio might not be available
      }

      debugLog('Audio file: $_currentAudioFileName');
      debugLog('French text: $_currentFrenchText');
    } catch (e) {
      _setError('Failed to generate number: $e');
      debugError('Error generating number: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> getAudioFilePath() async {
    if (_currentAudioFileName == null) return null;

    try {
      return await _audioService.getCachedAudioPath(_currentAudioFileName!);
    } catch (e) {
      _setError('Failed to get audio file: $e');
      return null;
    }
  }

  /// Play the current number's audio
  Future<void> playCurrentAudio() async {
    if (_currentAudioFileName == null) {
      _setError('No audio file available for current number');
      return;
    }

    try {
      await _audioService.playAudio(_currentAudioFileName!);
    } catch (e) {
      _setError('Failed to play audio: $e');
    }
  }

  /// Stop currently playing audio
  Future<void> stopAudio() async {
    try {
      await _audioService.stopAudio();
    } catch (e) {
      _setError('Failed to stop audio: $e');
    }
  }

  /// Check if audio is currently playing
  bool get isAudioPlaying => _audioService.isPlaying;

  /// Get current audio player state
  PlayerState get audioPlayerState => _audioService.playerState;

  Future<void> clearAudioCache() async {
    try {
      await _audioService.clearAudioCache();
      debugLog('Audio cache cleared');
    } catch (e) {
      _setError('Failed to clear audio cache: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentNumber() {
    _currentNumber = null;
    _currentAudioFileName = null;
    _currentFrenchText = null;
    _error = null;
    notifyListeners();
  }
}
