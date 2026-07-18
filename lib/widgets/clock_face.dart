import 'package:flutter/material.dart';

import '../models/clock_settings.dart';
import '../models/clock_theme.dart';
import '../utils/responsive.dart';
import 'date_view.dart';
import 'flip_clock.dart';

class ClockFace extends StatelessWidget {
  const ClockFace({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final compactHeight = size.height < 520;
        final verticalPadding = compactHeight ? 6.0 : 30.0;
        final hasDateHeader =
            settings.showWeekday ||
            settings.showDate ||
            !settings.use24HourFormat;
        final reservedHeaderHeight = hasDateHeader ? 24.0 : 0.0;
        final availableClockHeight =
            (size.height - verticalPadding * 2 - reservedHeaderHeight).clamp(
              120.0,
              size.height,
            );
        final clockHeightFactor = settings.showSeconds ? 1.40 : 1.0;
        final sizing = ResponsiveClock.sizing(
          size: Size(size.width, availableClockHeight),
          digitCount: 4,
          separatorCount: 1,
          fontScale: settings.fontScale,
          heightFactor: clockHeightFactor,
        );

        return Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: verticalPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DateView(now: now, settings: settings, theme: theme),
                SizedBox(height: sizing.digitHeight * 0.14),
                FlipClock(
                  now: now,
                  settings: settings,
                  theme: theme,
                  sizing: sizing,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
