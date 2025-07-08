import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  static const _key = 'app_locale';

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null && code != 'auto') {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null || code == 'auto') {
      _locale = null;
      await prefs.remove(_key);
    } else {
      _locale = Locale(code);
      await prefs.setString(_key, code);
    }
    notifyListeners();
  }
} 