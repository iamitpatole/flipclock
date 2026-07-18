import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/clock_settings.dart';
import '../models/clock_theme.dart';
import '../utils/time_format.dart';

class DateView extends StatelessWidget {
  const DateView({
    super.key,
    required this.now,
    required this.settings,
    required this.theme,
  });

  final DateTime now;
  final ClockSettings settings;
  final ClockTheme theme;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (settings.showWeekday) TimeFormat.weekday(now),
      if (settings.showDate) TimeFormat.date(now),
      if (!settings.use24HourFormat) TimeFormat.amPm(now),
    ];

    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        parts.join('  /  '),
        key: ValueKey(parts.join()),
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: theme.mutedDigit,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
