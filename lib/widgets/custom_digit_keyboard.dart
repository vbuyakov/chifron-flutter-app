import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DigitKeyboardKeyType { digit, backspace, enter, shift }

class DigitKeyboardKey {
  final DigitKeyboardKeyType type;
  final int? digit;
  const DigitKeyboardKey.digit(this.digit) : type = DigitKeyboardKeyType.digit;
  const DigitKeyboardKey.backspace() : type = DigitKeyboardKeyType.backspace, digit = null;
  const DigitKeyboardKey.enter() : type = DigitKeyboardKeyType.enter, digit = null;
  const DigitKeyboardKey.shift() : type = DigitKeyboardKeyType.shift, digit = null;
}

class CustomDigitKeyboard extends StatelessWidget {
  final void Function(DigitKeyboardKey key) onKeyTap;
  const CustomDigitKeyboard({super.key, required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxDecoration(
      color: Colors.black.withOpacity(0.85),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.cyanAccent.withOpacity(0.08),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1.5),
    );
    final textStyle = GoogleFonts.orbitron(
      color: Colors.cyanAccent,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
    final iconColor = Colors.deepPurpleAccent;
    return SizedBox(
      height: 260,
      child: Column(
        children: [
          for (var row in [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            ['backspace', 0, 'enter'],
          ])
            Expanded(
              child: Row(
                children: [
                  for (var item in row)
                    _AnimatedKeyboardButton(
                      label: item is int ? '$item' : null,
                      
                      icon: item == 'backspace'
                          ? Icons.backspace
                          : item == 'enter'
                              ? Icons.check_circle
                              : null,
                      style: buttonStyle,
                      textStyle: textStyle,
                      iconColor: item == 'backspace'
                          ? iconColor
                          : item == 'enter'
                              ? Colors.greenAccent
                              : null,
                      onTap: () {
                        if (item is int) {
                          onKeyTap(DigitKeyboardKey.digit(item));
                        } else if (item == 'backspace') {
                          onKeyTap(const DigitKeyboardKey.backspace());
                        } else if (item == 'enter') {
                          onKeyTap(const DigitKeyboardKey.enter());
                        }
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedKeyboardButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final BoxDecoration style;
  final TextStyle? textStyle;
  final Color? iconColor;
  final VoidCallback onTap;

  const _AnimatedKeyboardButton({
    super.key,
    this.label,
    this.icon,
    required this.style,
    this.textStyle,
    this.iconColor,
    required this.onTap,
  });

  @override
  State<_AnimatedKeyboardButton> createState() => _AnimatedKeyboardButtonState();
}

class _AnimatedKeyboardButtonState extends State<_AnimatedKeyboardButton> {
  double _scale = 1.0;

  void _animate() async {
    setState(() => _scale = 0.9);
    await Future.delayed(const Duration(milliseconds: 80));
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () {
            _animate();
            widget.onTap();
          },
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 80),
            child: Container(
              height: double.infinity,
              decoration: widget.style,
              child: Center(
                child: widget.icon != null
                    ? Icon(widget.icon, color: widget.iconColor ?? Colors.cyanAccent, size: 28)
                    : Text(widget.label ?? '', style: widget.textStyle,
                    textScaler: const TextScaler.linear(1.0),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 