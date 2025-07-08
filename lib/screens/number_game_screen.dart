import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chifron/widgets/custom_digit_keyboard.dart';
import 'package:chifron/widgets/number_game_input_area.dart';
import 'package:provider/provider.dart';
import 'package:chifron/providers/learn_number_provider.dart';
import 'package:chifron/providers/statistics_provider.dart';
import 'package:chifron/utils/debug_utils.dart';
import 'package:chifron/screens/start_screen.dart';
import 'package:chifron/constants.dart';
import 'package:chifron/providers/settings_provider.dart';

class NumberGameScreen extends StatefulWidget {
  const NumberGameScreen({super.key});

  @override
  State<NumberGameScreen> createState() => _NumberGameScreenState();
}

class _NumberGameScreenState extends State<NumberGameScreen>
    with TickerProviderStateMixin {
  String _inputValue = '';
  bool _shiftPressed = false;

  // Animation controllers
  late AnimationController _successAnimationController;
  late AnimationController _hoverAnimationController;
  late Animation<Offset> _successAnimation;
  late Animation<double> _successScaleAnimation;
  late Animation<double> _hoverScaleAnimation;

  String? _flyingValue;
  final GlobalKey _inputFieldKey = GlobalKey();
  final GlobalKey _successCounterKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();

  // Animation offset
  Offset _animationStart = Offset.zero;
  Offset _animationEnd = Offset.zero;

  // Wrong animation state
  bool _isWrongAnimating = false;
  bool _isWrongFlyAnimating = false; // true only while AE is animating
  String? _wrongValue;
  final GlobalKey _wrongTargetKey = GlobalKey();
  // For flying wrong value
  Offset _wrongFlyStart = Offset.zero;
  Offset _wrongFlyEnd = Offset.zero;
  Color _wrongFlyColor = Colors.orangeAccent;
  late AnimationController _wrongFlyController;
  late Animation<Offset> _wrongFlyAnimation;

  // Add state for showing correct value with fade-in
  bool _showCorrectFade = false;

  int? _currentNumber;
  late LearnNumberProvider _learnNumberProvider;
  int _replayCount = 0; // Track replay presses for current number

  // Add state variable
  bool _isReplayButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _successAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.easeInOut,
    ));

    _successScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.easeInOut,
    ));

    _hoverScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController,
      curve: Curves.elasticOut,
    ));

    _wrongFlyController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _wrongFlyAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _wrongFlyController,
      curve: Curves.easeInOut,
    ));

    _learnNumberProvider = LearnNumberProvider();
    _startNewRound();
  }

  @override
  void dispose() {
    _successAnimationController.dispose();
    _hoverAnimationController.dispose();
    _wrongFlyController.dispose();
    super.dispose();
  }

  void _handleKeyTap(DigitKeyboardKey key) {
    setState(() {
      if (key.type == DigitKeyboardKeyType.digit) {
        if (_inputValue.length < maxDigits) {
          _inputValue += key.digit.toString();
        }
      } else if (key.type == DigitKeyboardKeyType.backspace) {
        if (_inputValue.isNotEmpty) {
          _inputValue = _inputValue.substring(0, _inputValue.length - 1);
        }
      } else if (key.type == DigitKeyboardKeyType.enter) {
        if (_inputValue.isNotEmpty) {
          if (_inputValue == (_currentNumber?.toString() ?? '')) {
            _startSuccessAnimation();
          } else {
            _startWrongAnimation();
          }
        } else {
          // If input is empty, always mark as wrong and go to next number
          setState(() {
            _wrongValue = emptyWrongValuePlaceholder;
          });
          _startWrongAnimation(skipSetWrongValue: true);
        }
      } else if (key.type == DigitKeyboardKeyType.shift) {
        _shiftPressed = !_shiftPressed;
      }
    });
  }

  void _startSuccessAnimation() {
    setState(() {
      _flyingValue = _inputValue;
    });
    // Calculate the exact position of the success counter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? stackBox =
          _stackKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? inputBox =
          _inputFieldKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? counterBox =
          _successCounterKey.currentContext?.findRenderObject() as RenderBox?;
      if (stackBox != null && inputBox != null && counterBox != null) {
        final stackPosition = stackBox.localToGlobal(Offset.zero);
        final inputPosition =
            inputBox.localToGlobal(Offset.zero) - stackPosition;
        final counterPosition =
            counterBox.localToGlobal(Offset.zero) - stackPosition;
        final inputSize = inputBox.size;
        final counterSize = counterBox.size;
        // Start and end at the center of each element
        _animationStart =
            inputPosition + Offset(inputSize.width / 2, inputSize.height / 2);
        _animationEnd = counterPosition +
            Offset(counterSize.width / 2, counterSize.height / 2);
        _successAnimation = Tween<Offset>(
          begin: _animationStart,
          end: _animationEnd,
        ).animate(CurvedAnimation(
          parent: _successAnimationController,
          curve: Curves.easeInOut,
        ));
        _successAnimationController.forward().then((_) {
          if (!mounted) return;
          setState(() {
            _inputValue = '';
            _flyingValue = null;
          });
          // Save statistics
          Provider.of<StatisticsProvider>(context, listen: false).addResult(
              true, _currentNumber ?? 0,
              audioFileName: _learnNumberProvider.currentAudioFileName);
          _successAnimationController.reset();
          // Trigger hover effect
          _hoverAnimationController.forward().then((_) {
            if (!mounted) return;
            _hoverAnimationController.reverse();
            // Start new round after hover effect
            setState(() {
              _showCorrectFade = false;
            });
            _startNewRound();
          });
        });
      }
    });
  }

  void _startWrongAnimation({bool skipSetWrongValue = false}) async {
    setState(() {
      _isWrongAnimating = true;
      if (!skipSetWrongValue) {
        _wrongValue = _inputValue;
      }
      _inputValue = '';
    });
    setState(() {
      _showCorrectFade = true;
    });
    final delayWrong =
        Provider.of<SettingsProvider>(context, listen: false).delayWrong;
    await Future.delayed(Duration(milliseconds: (delayWrong * 1000).toInt()));
    setState(() {
      _showCorrectFade = false;
    });
    await _runWrongFlyAnimation(
        fromKey: _wrongTargetKey,
        toKey: _successCounterKey,
        color: Colors.redAccent);
    if (!mounted) return;
    setState(() {
      _isWrongAnimating = false;
      _wrongValue = null;
    });
    // Save statistics
    Provider.of<StatisticsProvider>(context, listen: false).addResult(
        false, _currentNumber ?? 0,
        audioFileName: _learnNumberProvider.currentAudioFileName);
    _startNewRound();
  }

  Future<void> _runWrongFlyAnimation(
      {required GlobalKey fromKey,
      required GlobalKey toKey,
      required Color color}) async {
    final RenderBox? stackBox =
        _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? fromBox =
        fromKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? toBox =
        toKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox != null && fromBox != null && toBox != null) {
      final stackPosition = stackBox.localToGlobal(Offset.zero);
      final fromPosition = fromBox.localToGlobal(Offset.zero) - stackPosition;
      final toPosition = toBox.localToGlobal(Offset.zero) - stackPosition;
      final fromSize = fromBox.size;
      final toSize = toBox.size;
      _wrongFlyStart = fromPosition +
          Offset(fromSize.width / 2,
              0); // Center horizontally, align to top vertically
      _wrongFlyEnd = toPosition + Offset(toSize.width / 2, toSize.height / 2);
      _wrongFlyColor = color;
      _wrongFlyAnimation = Tween<Offset>(
        begin: _wrongFlyStart,
        end: _wrongFlyEnd,
      ).animate(CurvedAnimation(
        parent: _wrongFlyController,
        curve: Curves.easeInOut,
      ));
      setState(() {
        _isWrongFlyAnimating = true;
      });
      await _wrongFlyController.forward(from: 0);
      _wrongFlyController.reset();
      setState(() {
        _isWrongFlyAnimating = false;
      });
    }
  }

  void _startNewRound() async {
    await _learnNumberProvider.generateRandomNumber();
    setState(() {
      _currentNumber = _learnNumberProvider.currentNumber;
      _replayCount = 0; // Reset replay count for new number
    });

    // Auto-play audio for the new number
    if (_learnNumberProvider.currentAudioFileName != null) {
      try {
        await _learnNumberProvider.playCurrentAudio();
      } catch (e) {
        // Handle audio playback error silently
        debugError('Auto-play audio error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
              ),
              child: Center(
                child: Text(
                  loc.menuPlaceholder,
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.cyanAccent),
              title: Text(loc.settings,
                  style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(loc.appTitle),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.85),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent, size: 36),
            tooltip: loc.finishGame,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const StartScreen()),
                (route) => false,
              );
            },
          ),
        ],
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
        child: SafeArea(
          child: Stack(
            key: _stackKey,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Score bar
                    Consumer<StatisticsProvider>(
                      builder: (context, statistics, child) {
                        final todayStats = statistics.todayStats;
                        final todayPercent = todayStats?.percent ?? 0.0;
                        final todayCorrect = todayStats?.correct ?? 0;
                        final todayWrong = todayStats?.wrong ?? 0;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${loc.score}: ${todayPercent.toStringAsFixed(1)}%',
                                style: GoogleFonts.orbitron(
                                  color: Colors.cyanAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(children: [
                                Icon(Icons.close,
                                    color: Colors.redAccent, size: 22),
                                SizedBox(width: 4),
                                Text('$todayWrong',
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 18)),
                              ]),
                              AnimatedBuilder(
                                animation: _hoverAnimationController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _hoverScaleAnimation.value,
                                    child: Row(
                                      key: _successCounterKey,
                                      children: [
                                        Icon(Icons.check,
                                            color: Colors.greenAccent,
                                            size: 22),
                                        SizedBox(width: 4),
                                        Text('$todayCorrect',
                                            style: TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Loading and error indicators
                    Consumer<LearnNumberProvider>(
                      builder: (context, learnProvider, child) {
                        if (learnProvider.isLoading) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.cyanAccent),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Loading number...',
                                  style: GoogleFonts.orbitron(
                                    color: Colors.cyanAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (learnProvider.error != null) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.redAccent),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.redAccent),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    learnProvider.error!,
                                    style: GoogleFonts.orbitron(
                                      color: Colors.redAccent,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.refresh,
                                      color: Colors.redAccent),
                                  onPressed: () => _startNewRound(),
                                ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    // Number game input area
                    NumberGameInputArea(
                      isWrongAnimating: _isWrongAnimating,
                      isWrongFlyAnimating: _isWrongFlyAnimating,
                      wrongValue: _wrongValue,
                      wrongTargetKey: _wrongTargetKey,
                      maxDigits: maxDigits,
                      showCorrectFade: _showCorrectFade,
                      correctValue: _currentNumber?.toString() ?? '',
                      inputValue: _inputValue,
                      inputFieldKey: _inputFieldKey,
                    ),
                    const SizedBox(height: 24),
                    // Speaker (Replay) button
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Consumer<LearnNumberProvider>(
                            builder: (context, learnProvider, child) {
                              final replaysLeft =
                                  (maxReplayCount - _replayCount)
                                      .clamp(0, maxReplayCount);
                              final isReplayLimit =
                                  _replayCount >= maxReplayCount;
                              return IconButton(
                                icon: Icon(
                                  Icons.volume_up,
                                  size: 36,
                                  color: Colors.cyanAccent,
                                ),
                                onPressed: _isReplayButtonDisabled ||
                                        learnProvider.isAudioPlaying ||
                                        isReplayLimit
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isReplayButtonDisabled = true;
                                          _replayCount++;
                                        });
                                        // Play audio
                                        try {
                                          await _learnNumberProvider
                                              .playCurrentAudio();
                                        } catch (e) {
                                          debugError(
                                              'Audio playback error: $e');
                                        }
                                        await Future.delayed(Duration(
                                            milliseconds:
                                                replayButtonCooldownMs));
                                        if (mounted) {
                                          setState(() {
                                            _isReplayButtonDisabled = false;
                                          });
                                        }
                                        // If this was the last allowed replay and input is empty or wrong, fire wrong scenario
                                        if (_replayCount >= maxReplayCount &&
                                            (_inputValue.isEmpty ||
                                                _inputValue !=
                                                    (_currentNumber
                                                            ?.toString() ??
                                                        ''))) {
                                          setState(() {
                                            _wrongValue = _inputValue.isEmpty
                                                ? emptyWrongValuePlaceholder
                                                : _inputValue;
                                          });
                                          _startWrongAnimation(
                                              skipSetWrongValue: true);
                                        }
                                      },
                              );
                            },
                          ),
                          // Badge for replays left
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${(maxReplayCount - _replayCount).clamp(0, maxReplayCount)}',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Spacer(),
                    // Custom digit keyboard
                    CustomDigitKeyboard(
                      onKeyTap: _handleKeyTap,
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
              // Flying success animation overlay
              if (_flyingValue != null)
                AnimatedBuilder(
                  animation: _successAnimationController,
                  builder: (context, child) {
                    return Positioned(
                      left: _successAnimation.value.dx,
                      top: _successAnimation.value.dy,
                      child: Transform.scale(
                        scale: _successScaleAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            _flyingValue!,
                            style: GoogleFonts.orbitron(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              // Flying wrong value animation (must be direct child of Stack)
              if (_isWrongFlyAnimating && _wrongValue != null)
                AnimatedBuilder(
                  animation: _wrongFlyController,
                  builder: (context, child) {
                    return Positioned(
                      left: _wrongFlyAnimation.value.dx,
                      top: _wrongFlyAnimation.value.dy,
                      child: Transform.scale(
                        scale: 1.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _wrongFlyColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _wrongFlyColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            _wrongValue!,
                            style: GoogleFonts.orbitron(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
