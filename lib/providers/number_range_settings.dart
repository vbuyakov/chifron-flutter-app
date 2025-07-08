import 'package:shared_preferences/shared_preferences.dart';
import 'package:chifron/models/number_range.dart';
import 'package:chifron/constants.dart';

class NumberRangeSettings {
  static const _keyMinValue = 'min_value';
  static const _keyMaxValue = 'max_value';
  static const _keyLabel = 'range_label';

  static const List<NumberRange> presets = numberRangePresets;

  int minValue = presets[0].min;
  int maxValue = presets[0].max;
  String label = presets[0].label;

  NumberRange get currentPreset {
    for (final preset in presets) {
      if (preset.matches(minValue, maxValue, label)) {
        return preset;
      }
    }
    // If no match, reset to first preset
    setPreset(presets[0]);
    return presets[0];
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    minValue = prefs.getInt(_keyMinValue) ?? presets[0].min;
    maxValue = prefs.getInt(_keyMaxValue) ?? presets[0].max;
    label = prefs.getString(_keyLabel) ?? presets[0].label;
    // Ensure always a valid preset
    bool found = false;
    for (final preset in presets) {
      if (preset.matches(minValue, maxValue, label)) {
        found = true;
        break;
      }
    }
    if (!found) {
      await setPreset(presets[0]);
    }
  }

  Future<void> setPreset(NumberRange range) async {
    final prefs = await SharedPreferences.getInstance();
    minValue = range.min;
    maxValue = range.max;
    label = range.label;
    await prefs.setInt(_keyMinValue, minValue);
    await prefs.setInt(_keyMaxValue, maxValue);
    await prefs.setString(_keyLabel, label);
  }
}
