import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class ClockSizing {
  const ClockSizing({
    required this.digitWidth,
    required this.digitHeight,
    required this.spacing,
    required this.separatorWidth,
  });

  final double digitWidth;
  final double digitHeight;
  final double spacing;
  final double separatorWidth;

  ClockSizing scaled(double factor) {
    return ClockSizing(
      digitWidth: digitWidth * factor,
      digitHeight: digitHeight * factor,
      spacing: spacing * factor,
      separatorWidth: separatorWidth * factor,
    );
  }
}

class ResponsiveClock {
  const ResponsiveClock._();

  static ClockSizing sizing({
    required Size size,
    required int digitCount,
    required int separatorCount,
    required double fontScale,
    double heightFactor = 1,
  }) {
    final compactHeight = size.height < 520;
    final horizontalPadding = size.width < 700 ? 28.0 : 64.0;
    final maxClockWidth = size.width - horizontalPadding;
    final ratio = compactHeight ? 0.85 : 0.82;
    final baseDigitWidth =
        maxClockWidth / (digitCount + separatorCount * 0.32 + 0.7);
    final heightBasedWidth = size.height * ratio / heightFactor / 1.32;
    final digitWidth = math.min(baseDigitWidth, heightBasedWidth);
    final scaledWidth = digitWidth * fontScale.clamp(0.82, 1.22);
    final minimumWidth = compactHeight ? 30.0 : 38.0;
    final clampedWidth = math.max(minimumWidth, math.min(scaledWidth, 200.0));
    return ClockSizing(
      digitWidth: clampedWidth,
      digitHeight: clampedWidth * 1.32,
      spacing: math.max(5.0, clampedWidth * 0.08),
      separatorWidth: math.max(14.0, clampedWidth * 0.25),
    );
  }
}
