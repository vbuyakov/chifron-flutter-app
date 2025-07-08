import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:chifron/providers/locale_provider.dart';
import 'package:chifron/providers/settings_provider.dart';
import 'package:chifron/providers/number_range_settings.dart';
import 'package:chifron/screens/start_screen.dart';
import 'package:flutter/services.dart';
import 'package:chifron/models/number_range.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double? delayCorrect;
  double? delayWrong;
  late NumberRangeSettings _rangeSettings;
  late NumberRange _selectedRange;
  bool _hasImportantChanges = false; // Track if range or score was changed

  @override
  void initState() {
    super.initState();
    _rangeSettings = NumberRangeSettings();
    _selectedRange = NumberRangeSettings.presets[0];
    _loadRange();
  }

  Future<void> _loadRange() async {
    await _rangeSettings.load();
    setState(() {
      _selectedRange = _rangeSettings.currentPreset;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    delayCorrect = Provider.of<SettingsProvider>(context).delayCorrect;
    delayWrong = Provider.of<SettingsProvider>(context).delayWrong;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final baseStyle =
        GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 18);
    final settings = Provider.of<SettingsProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final language = localeProvider.locale?.languageCode ?? 'auto';
    return WillPopScope(
      onWillPop: () async {
        if (_hasImportantChanges) {
          // Navigate to start screen if important changes were made
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const StartScreen(),
            ),
            (route) => false,
          );
          return false; // Prevent default back behavior
        }
        return true; // Allow default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.settings,
              style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
          backgroundColor: Colors.black.withOpacity(0.85),
          iconTheme: const IconThemeData(color: Colors.cyanAccent),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_hasImportantChanges) {
                // Navigate to start screen if important changes were made
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const StartScreen(),
                  ),
                  (route) => false,
                );
              } else {
                // Normal back navigation
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0f2027),
                Color(0xFF2c5364),
                Color(0xFF232526),
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Language selector
              Text(loc.language, style: baseStyle),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: language,
                      dropdownColor: Colors.black,
                      style: baseStyle,
                      items: [
                        DropdownMenuItem(value: 'auto', child: Text(loc.auto)),
                        DropdownMenuItem(value: 'en', child: Text(loc.english)),
                        DropdownMenuItem(
                            value: 'uk', child: Text(loc.ukrainian)),
                        DropdownMenuItem(
                            value: 'pt', child: Text(loc.portuguese)),
                        DropdownMenuItem(value: 'es', child: Text(loc.spanish)),
                        DropdownMenuItem(value: 'de', child: Text(loc.german)),
                        DropdownMenuItem(value: 'it', child: Text(loc.italian)),
                      ],
                      onChanged: (val) async {
                        await localeProvider.setLocale(val);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Number range selector
              Text('${loc.minValue} - ${loc.maxValue}', style: baseStyle),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<NumberRange>(
                      value: _selectedRange,
                      dropdownColor: Colors.black,
                      style: baseStyle,
                      items: NumberRangeSettings.presets
                          .map((range) => DropdownMenuItem<NumberRange>(
                                value: range,
                                child: Text(range.label, style: baseStyle),
                              ))
                          .toList(),
                      onChanged: (NumberRange? newRange) async {
                        if (newRange != null) {
                          await _rangeSettings.setPreset(newRange);
                          setState(() {
                            _selectedRange = newRange;
                            _hasImportantChanges =
                                true; // Mark that range was changed
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Delay for correct
              Text(loc.delayCorrect, style: baseStyle),
              const SizedBox(height: 8),
              _StyledDoubleDropdown(
                value: delayCorrect ?? 0.5,
                min: 0.5,
                max: 20.0,
                step: 0.5,
                onChanged: (v) async {
                  if (v != null) {
                    setState(() => delayCorrect = v);
                    await settings.setDelayCorrect(v);
                  }
                },
              ),
              const SizedBox(height: 24),
              // Delay for wrong
              Text(loc.delayWrong, style: baseStyle),
              const SizedBox(height: 8),
              _StyledDoubleDropdown(
                value: delayWrong ?? 2.0,
                min: 0.5,
                max: 20.0,
                step: 0.5,
                onChanged: (v) async {
                  if (v != null) {
                    setState(() => delayWrong = v);
                    await settings.setDelayWrong(v);
                  }
                },
              ),
              const SizedBox(height: 32),
              // Reset score button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.orbitron(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black,
                        title: Text(loc.resetScore,
                            style: baseStyle.copyWith(color: Colors.redAccent)),
                        content: Text(loc.resetScoreConfirm, style: baseStyle),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(loc.cancel, style: baseStyle),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(loc.reset,
                                style: baseStyle.copyWith(
                                    color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await settings.resetScore(context);
                      setState(() {
                        _hasImportantChanges =
                            true; // Mark that score was reset
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Score reset!',
                              style: baseStyle.copyWith(color: Colors.white)),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text(loc.resetScore),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyledNumberField extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const _StyledNumberField(
      {required this.value,
      required this.min,
      required this.max,
      required this.onChanged,
      super.key});

  @override
  State<_StyledNumberField> createState() => _StyledNumberFieldState();
}

class _StyledNumberFieldState extends State<_StyledNumberField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant _StyledNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value.toString() != _controller.text) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitValue() {
    final parsed = int.tryParse(_controller.text) ?? widget.min;
    if (parsed >= widget.min && parsed <= widget.max) {
      widget.onChanged(parsed);
    } else {
      // Optionally reset to last valid value
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 18),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        onEditingComplete: _submitValue,
        onSubmitted: (_) => _submitValue(),
      ),
    );
  }
}

class _StyledDoubleDropdown extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double?>? onChanged;
  const _StyledDoubleDropdown(
      {required this.value,
      required this.min,
      required this.max,
      required this.step,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 18);
    final items = [for (double v = min; v <= max; v += step) v]
        .map((v) => DropdownMenuItem<double>(
            value: v, child: Text(v.toStringAsFixed(1), style: baseStyle)))
        .toList();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<double>(
            value: value,
            dropdownColor: Colors.black,
            style: baseStyle,
            items: items,
            onChanged: (v) => onChanged?.call(v),
          ),
        ),
      ),
    );
  }
}
