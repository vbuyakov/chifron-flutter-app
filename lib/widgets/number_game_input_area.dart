// ===== PROTECTED FILE - DO NOT MODIFY =====
// This entire file contains working game functionality
// Any changes to this file will break the number game
// If modifications are needed, create a new file instead
// ===== END PROTECTED FILE =====

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberGameInputArea extends StatelessWidget {
  final bool isWrongAnimating;
  final bool isWrongFlyAnimating;
  final String? wrongValue;
  final Key? wrongTargetKey;
  final int maxDigits;
  final bool showCorrectFade;
  final String correctValue;
  final String inputValue;
  final Key? inputFieldKey;

  const NumberGameInputArea({
    super.key,
    required this.isWrongAnimating,
    required this.isWrongFlyAnimating,
    required this.wrongValue,
    required this.wrongTargetKey,
    required this.maxDigits,
    required this.showCorrectFade,
    required this.correctValue,
    required this.inputValue,
    required this.inputFieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wrong value display
        Center(
          key: wrongTargetKey,
          child: SizedBox(
            height: 36,
            child: AnimatedOpacity(
              opacity: (isWrongAnimating && !isWrongFlyAnimating && wrongValue != null) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                wrongValue ?? '',
                style: GoogleFonts.orbitron(
                  color: Colors.redAccent,
                  fontSize: 26,
                  decoration: TextDecoration.lineThrough,
                  
                ),
                textScaler: const TextScaler.linear(1.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Input field (maxDigits)
        Center(
          key: inputFieldKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.15),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(maxDigits, (index) {
                    if (showCorrectFade) {
                      // Show only the correct value in green, with underscores for empty positions
                      String digit = '';
                      if (index >= maxDigits - correctValue.length) {
                        digit = correctValue[index - (maxDigits - correctValue.length)];
                      }
                      return Container(
                        width: 32,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Center(
                          child: Text(
                            digit.isEmpty ? '_' : digit,
                            style: GoogleFonts.orbitron(
                              fontSize: 36,
                              color: Colors.lightGreenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                        ),
                      );
                    } else {
                      // Show user input as usual
                      String digit = '';
                      if (index >= maxDigits - inputValue.length) {
                        digit = inputValue[index - (maxDigits - inputValue.length)];
                      }
                      return Container(
                        width: 32, // Fixed width for each digit
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Center(
                          child: Text(
                            digit.isEmpty ? '_' : digit,
                            style: GoogleFonts.orbitron(
                              fontSize: 36,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1.0),
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
              if (showCorrectFade)
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 1200),
                  child: SizedBox.shrink(), // No overlay, handled above
                ),
            ],
          ),
        ),
      ],
    );
  }
} 