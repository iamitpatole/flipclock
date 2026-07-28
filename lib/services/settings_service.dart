import 'package:shared_preferences/shared_preferences.dart';

import '../models/clock_settings.dart';

class SettingsService {
  static const _use24HourFormat = 'use24HourFormat';
  static const _showSeconds = 'showSeconds';
  static const _showDate = 'showDate';
  static const _showWeekday = 'showWeekday';
  static const _themeId = 'themeId';
  static const _accentColorValue = 'accentColorValue';
  static const _animationSpeed = 'animationSpeed';
  static const _fontScale = 'fontScale';
  static const _keepScreenAwake = 'keepScreenAwake';
  static const _fullscreen = 'fullscreen';
  static const _waterReminderEnabled = 'waterReminderEnabled';
  static const _waterReminderIntervalSeconds = 'waterReminderIntervalSeconds';
  static const _nextWaterReminderTimestamp = 'nextWaterReminderTimestamp';

  Future<ClockSettings> load() async {
    final preferences = await SharedPreferences.getInstance();
    return ClockSettings(
      use24HourFormat: preferences.getBool(_use24HourFormat) ?? true,
      showSeconds: preferences.getBool(_showSeconds) ?? true,
      showDate: preferences.getBool(_showDate) ?? true,
      showWeekday: preferences.getBool(_showWeekday) ?? true,
      themeId: preferences.getString(_themeId) ?? 'classic_black',
      accentColorValue: preferences.getInt(_accentColorValue) ?? 0xFF38BDF8,
      animationSpeed: preferences.getDouble(_animationSpeed) ?? 1,
      fontScale: preferences.getDouble(_fontScale) ?? 1,
      keepScreenAwake: preferences.getBool(_keepScreenAwake) ?? true,
      fullscreen: preferences.getBool(_fullscreen) ?? false,
      waterReminderEnabled:
          preferences.getBool(_waterReminderEnabled) ?? false,
      waterReminderIntervalSeconds:
          preferences.getInt(_waterReminderIntervalSeconds) ?? 3600,
      nextWaterReminderTimestamp:
          preferences.getInt(_nextWaterReminderTimestamp) ?? 0,
    );
  }

  Future<void> save(ClockSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setBool(_use24HourFormat, settings.use24HourFormat),
      preferences.setBool(_showSeconds, settings.showSeconds),
      preferences.setBool(_showDate, settings.showDate),
      preferences.setBool(_showWeekday, settings.showWeekday),
      preferences.setString(_themeId, settings.themeId),
      preferences.setInt(_accentColorValue, settings.accentColorValue),
      preferences.setDouble(_animationSpeed, settings.animationSpeed),
      preferences.setDouble(_fontScale, settings.fontScale),
      preferences.setBool(_keepScreenAwake, settings.keepScreenAwake),
      preferences.setBool(_fullscreen, settings.fullscreen),
      preferences.setBool(_waterReminderEnabled, settings.waterReminderEnabled),
      preferences.setInt(_waterReminderIntervalSeconds,
          settings.waterReminderIntervalSeconds),
      preferences.setInt(_nextWaterReminderTimestamp,
          settings.nextWaterReminderTimestamp),
    ]);
  }
}
