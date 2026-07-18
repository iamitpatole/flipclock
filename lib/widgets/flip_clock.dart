import 'package:flutter/material.dart';

import '../models/clock_settings.dart';
import '../models/clock_theme.dart';
import '../utils/responsive.dart';
import '../utils/time_format.dart';
import 'clock_separator.dart';
import 'flip_digit.dart';

class FlipClock extends StatelessWidget {
  const FlipClock({
    super.key,
    required this.now,
    required this.settings,
    required this.theme,
    required this.sizing,
  });

  final DateTime now;
  final ClockSettings settings;
  final ClockTheme theme;
  final ClockSizing sizing;

  @override
  Widget build(BuildContext context) {
    final hours = TimeFormat.hours(now, settings);
    final minutes = TimeFormat.minutes(now);
    final seconds = TimeFormat.seconds(now);
    final duration = Duration(
      milliseconds: (680 / settings.animationSpeed).round().clamp(280, 1200),
    );
    final fontSize = sizing.digitHeight * 0.90;
    final secondsScale = 0.20;
    final secondsSizing = sizing.scaled(secondsScale);
    final secondsFontSize = fontSize * secondsScale;

    return Semantics(
      label: _semanticLabel(now, settings),
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DigitPair(
                value: hours,
                sizing: sizing,
                theme: theme,
                duration: duration,
                fontSize: fontSize,
              ),
              SizedBox(width: sizing.spacing),
              ClockSeparator(
                height: sizing.digitHeight,
                width: sizing.separatorWidth,
                theme: theme,
              ),
              SizedBox(width: sizing.spacing),
              _DigitPair(
                value: minutes,
                sizing: sizing,
                theme: theme,
                duration: duration,
                fontSize: fontSize,
              ),
            ],
          ),
          if (settings.showSeconds) ...[
            SizedBox(height: sizing.spacing * 1.4),
            _DigitPair(
              value: seconds,
              sizing: secondsSizing,
              theme: theme,
              duration: duration,
              fontSize: secondsFontSize,
            ),
          ],
        ],
      ),
    );
  }
}

class _DigitPair extends StatelessWidget {
  const _DigitPair({
    required this.value,
    required this.sizing,
    required this.theme,
    required this.duration,
    required this.fontSize,
  });

  final String value;
  final ClockSizing sizing;
  final ClockTheme theme;
  final Duration duration;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlipDigit(
          value: value[0],
          width: sizing.digitWidth,
          height: sizing.digitHeight,
          theme: theme,
          duration: duration,
          fontSize: fontSize,
        ),
        SizedBox(width: sizing.spacing),
        FlipDigit(
          value: value[1],
          width: sizing.digitWidth,
          height: sizing.digitHeight,
          theme: theme,
          duration: duration,
          fontSize: fontSize,
        ),
      ],
    );
  }
}

String _semanticLabel(DateTime now, ClockSettings settings) {
  final base =
      '${TimeFormat.hours(now, settings)}:${TimeFormat.minutes(now)}'
      '${settings.showSeconds ? ':${TimeFormat.seconds(now)}' : ''}';
  return settings.use24HourFormat ? base : '$base ${TimeFormat.amPm(now)}';
}
