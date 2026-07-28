import 'package:flutter/material.dart';

@immutable
class ClockSettings {
  const ClockSettings({
    this.use24HourFormat = true,
    this.showSeconds = true,
    this.showDate = true,
    this.showWeekday = true,
    this.themeId = 'classic_black',
    this.accentColorValue = 0xFF38BDF8,
    this.animationSpeed = 1,
    this.fontScale = 1,
    this.keepScreenAwake = true,
    this.fullscreen = false,
    this.waterReminderEnabled = false,
    this.waterReminderIntervalSeconds = 3600, // default 1 hour (3600 seconds)
    this.nextWaterReminderTimestamp = 0,
  });

  final bool use24HourFormat;
  final bool showSeconds;
  final bool showDate;
  final bool showWeekday;
  final String themeId;
  final int accentColorValue;
  final double animationSpeed;
  final double fontScale;
  final bool keepScreenAwake;
  final bool fullscreen;
  final bool waterReminderEnabled;
  final int waterReminderIntervalSeconds;
  final int nextWaterReminderTimestamp;

  Color get accentColor => Color(accentColorValue);

  ClockSettings copyWith({
    bool? use24HourFormat,
    bool? showSeconds,
    bool? showDate,
    bool? showWeekday,
    String? themeId,
    int? accentColorValue,
    double? animationSpeed,
    double? fontScale,
    bool? keepScreenAwake,
    bool? fullscreen,
    bool? waterReminderEnabled,
    int? waterReminderIntervalSeconds,
    int? nextWaterReminderTimestamp,
  }) {
    return ClockSettings(
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      showSeconds: showSeconds ?? this.showSeconds,
      showDate: showDate ?? this.showDate,
      showWeekday: showWeekday ?? this.showWeekday,
      themeId: themeId ?? this.themeId,
      accentColorValue: accentColorValue ?? this.accentColorValue,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      fontScale: fontScale ?? this.fontScale,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      fullscreen: fullscreen ?? this.fullscreen,
      waterReminderEnabled: waterReminderEnabled ?? this.waterReminderEnabled,
      waterReminderIntervalSeconds:
          waterReminderIntervalSeconds ?? this.waterReminderIntervalSeconds,
      nextWaterReminderTimestamp:
          nextWaterReminderTimestamp ?? this.nextWaterReminderTimestamp,
    );
  }
}
