import 'package:flutter/material.dart';

class ClockTheme {
  const ClockTheme({
    required this.id,
    required this.name,
    required this.background,
    required this.cardTop,
    required this.cardBottom,
    required this.digit,
    required this.mutedDigit,
    required this.accent,
    required this.shadow,
    this.glow,
  });

  final String id;
  final String name;
  final Color background;
  final Color cardTop;
  final Color cardBottom;
  final Color digit;
  final Color mutedDigit;
  final Color accent;
  final Color shadow;
  final Color? glow;

  bool get isLight => background.computeLuminance() > 0.5;
}
