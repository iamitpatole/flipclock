import 'package:flutter/material.dart';

import '../models/clock_theme.dart';

class ClockSeparator extends StatelessWidget {
  const ClockSeparator({
    super.key,
    required this.height,
    required this.width,
    required this.theme,
  });

  final double height;
  final double width;
  final ClockTheme theme;

  @override
  Widget build(BuildContext context) {
    final dotSize = (width * 0.36).clamp(5.0, 15.0);
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Dot(size: dotSize, theme: theme),
          SizedBox(height: height * 0.16),
          _Dot(size: dotSize, theme: theme),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.theme});

  final double size;
  final ClockTheme theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.digit,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.glow ?? theme.shadow,
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}
