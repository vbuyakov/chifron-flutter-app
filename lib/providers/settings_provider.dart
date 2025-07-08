import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:chifron/providers/statistics_provider.dart';

class SettingsProvider extends ChangeNotifier {
  static const _keyDelayCorrect = 'delay_correct';
  static const _keyDelayWrong = 'delay_wrong';

  double _delayCorrect = 0.5;
  double _delayWrong = 2.0;

  double get delayCorrect => _delayCorrect;
  double get delayWrong => _delayWrong;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _delayCorrect = prefs.getDouble(_keyDelayCorrect) ?? 0.5;
    _delayWrong = prefs.getDouble(_keyDelayWrong) ?? 2.0;
    notifyListeners();
  }

  Future<void> setDelayCorrect(double value) async {
    final prefs = await SharedPreferences.getInstance();
    _delayCorrect = value;
    await prefs.setDouble(_keyDelayCorrect, value);
    notifyListeners();
  }

  Future<void> setDelayWrong(double value) async {
    final prefs = await SharedPreferences.getInstance();
    _delayWrong = value;
    await prefs.setDouble(_keyDelayWrong, value);
    notifyListeners();
  }

  Future<void> resetScore(BuildContext context) async {
    await Provider.of<StatisticsProvider>(context, listen: false)
        .resetAllStatistics();
    notifyListeners();
  }
}
