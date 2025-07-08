import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chifron/models/daily_stats.dart';
import 'package:chifron/models/number_game_record.dart';

class StatisticsProvider extends ChangeNotifier {
  static const _keyDailyStats = 'daily_stats';
  static const _keyNumberGameRecords = 'number_game_records';

  List<DailyStats> _dailyStats = [];
  List<NumberGameRecord> _numberGameRecords = [];

  List<DailyStats> get dailyStats => _dailyStats;
  List<NumberGameRecord> get numberGameRecords => _numberGameRecords;

  StatisticsProvider() {
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();

    // Load daily stats
    final statsJson = prefs.getStringList(_keyDailyStats) ?? [];
    _dailyStats =
        statsJson.map((json) => DailyStats.fromJson(jsonDecode(json))).toList();

    // Load number game records
    final recordsJson = prefs.getStringList(_keyNumberGameRecords) ?? [];
    _numberGameRecords = recordsJson
        .map((json) => NumberGameRecord.fromJson(jsonDecode(json)))
        .toList();

    notifyListeners();
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();

    // Save daily stats
    final statsJson =
        _dailyStats.map((stats) => jsonEncode(stats.toJson())).toList();
    await prefs.setStringList(_keyDailyStats, statsJson);

    // Save number game records
    final recordsJson = _numberGameRecords
        .map((record) => jsonEncode(record.toJson()))
        .toList();
    await prefs.setStringList(_keyNumberGameRecords, recordsJson);
  }

  Future<void> addResult(bool isCorrect, int number,
      {String? audioFileName}) async {
    final now = DateTime.now();

    // Update daily statistics
    final today = DateTime(now.year, now.month, now.day);
    final existingIndex = _dailyStats.indexWhere((stats) =>
        DateTime(stats.date.year, stats.date.month, stats.date.day) == today);

    if (existingIndex >= 0) {
      final existing = _dailyStats[existingIndex];
      _dailyStats[existingIndex] = existing.copyWith(
        correct: existing.correct + (isCorrect ? 1 : 0),
        wrong: existing.wrong + (isCorrect ? 0 : 1),
      );
    } else {
      _dailyStats.add(DailyStats(
        date: today,
        correct: isCorrect ? 1 : 0,
        wrong: isCorrect ? 0 : 1,
      ));
    }

    // Update or create number game record
    final numberIndex =
        _numberGameRecords.indexWhere((record) => record.number == number);
    final currentTotalCorrect =
        _dailyStats.fold(0, (sum, stats) => sum + stats.correct);
    final currentTotalWrong =
        _dailyStats.fold(0, (sum, stats) => sum + stats.wrong);

    if (numberIndex >= 0) {
      // Update existing record for this number
      _numberGameRecords[numberIndex] =
          _numberGameRecords[numberIndex].copyWith(
        lastResult: isCorrect ? 'correct' : 'wrong',
        totalCorrect: currentTotalCorrect,
        totalWrong: currentTotalWrong,
        dateTime: now,
        audioFileName: audioFileName,
      );
    } else {
      // Create new record for this number
      _numberGameRecords.add(NumberGameRecord(
        number: number,
        lastResult: isCorrect ? 'correct' : 'wrong',
        totalCorrect: currentTotalCorrect,
        totalWrong: currentTotalWrong,
        dateTime: now,
        audioFileName: audioFileName,
      ));
    }

    await _saveStatistics();
    notifyListeners();
  }

  // Get overall statistics across all days
  int get totalCorrect {
    return _dailyStats.fold(0, (sum, stats) => sum + stats.correct);
  }

  int get totalWrong {
    return _dailyStats.fold(0, (sum, stats) => sum + stats.wrong);
  }

  double get overallPercent {
    final correct = totalCorrect;
    final wrong = totalWrong;
    return (correct + wrong) > 0 ? (correct / (correct + wrong)) * 100 : 0;
  }

  // Get today's statistics
  DailyStats? get todayStats {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    return _dailyStats.firstWhere(
      (stats) =>
          DateTime(stats.date.year, stats.date.month, stats.date.day) ==
          todayKey,
      orElse: () => DailyStats(date: todayKey, correct: 0, wrong: 0),
    );
  }

  // Get statistics for a specific date
  DailyStats? getStatsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);

    return _dailyStats.firstWhere(
      (stats) =>
          DateTime(stats.date.year, stats.date.month, stats.date.day) ==
          dateKey,
      orElse: () => DailyStats(date: dateKey, correct: 0, wrong: 0),
    );
  }

  // Get record for a specific number
  NumberGameRecord? getRecordForNumber(int number) {
    try {
      return _numberGameRecords.firstWhere((record) => record.number == number);
    } catch (e) {
      return null;
    }
  }

  // Get all records for a specific number
  List<NumberGameRecord> getRecordsForNumber(int number) {
    return _numberGameRecords
        .where((record) => record.number == number)
        .toList();
  }

  // Get recent records (last N)
  List<NumberGameRecord> getRecentRecords(int count) {
    final sortedRecords = List<NumberGameRecord>.from(_numberGameRecords);
    sortedRecords.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sortedRecords.take(count).toList();
  }

  // Reset all statistics
  Future<void> resetAllStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDailyStats);
    await prefs.remove(_keyNumberGameRecords);
    _dailyStats.clear();
    _numberGameRecords.clear();
    notifyListeners();
  }

  // Get last N days statistics
  List<DailyStats> getLastNDays(int n) {
    final today = DateTime.now();
    final result = <DailyStats>[];

    for (int i = 0; i < n; i++) {
      final date = today.subtract(Duration(days: i));
      final stats = getStatsForDate(date);
      if (stats != null) {
        result.add(stats);
      }
    }

    return result.reversed.toList();
  }
}
