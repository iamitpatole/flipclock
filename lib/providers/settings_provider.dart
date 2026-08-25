import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/clock_settings.dart';
import '../models/clock_theme.dart';
import '../services/screen_service.dart';
import '../services/rating_service.dart';
import '../services/settings_service.dart';
import '../theme/clock_themes.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._settingsService, this._screenService) {
    _load();
  }

  final SettingsService _settingsService;
  final ScreenService _screenService;

  ClockSettings _settings = const ClockSettings();
  bool _isLoaded = false;

  ClockSettings get settings => _settings;
  bool get isLoaded => _isLoaded;
  ClockTheme get clockTheme => ClockThemes.byId(_settings.themeId);

  Timer? _waterReminderTimer;
  Timer? _animationHideTimer;
  bool _showWaterAnimation = false;

  bool get showWaterAnimation => _showWaterAnimation;

  Future<void> _load() async {
    await RatingService().trackLaunch();
    _settings = await _settingsService.load();
    _isLoaded = true;
    await _screenService.apply(
      keepScreenAwake: _settings.keepScreenAwake,
      fullscreen: _settings.fullscreen,
    );
    _startWaterReminderTimer();
    notifyListeners();
  }

  void _startWaterReminderTimer() {
    _waterReminderTimer?.cancel();
    _waterReminderTimer = null;

    if (!_settings.waterReminderEnabled) return;
    if (_showWaterAnimation) return; // Don't schedule next reminder while animation is showing

    if (_settings.nextWaterReminderTimestamp == 0) {
      final nextTimestamp = DateTime.now().millisecondsSinceEpoch +
          _settings.waterReminderIntervalSeconds * 1000;
      _settings = _settings.copyWith(nextWaterReminderTimestamp: nextTimestamp);
      _settingsService.save(_settings);
    }

    final remaining = _settings.nextWaterReminderTimestamp -
        DateTime.now().millisecondsSinceEpoch;

    if (remaining <= 0) {
      // Trigger reminder immediately if the scheduled time has already passed
      triggerWaterReminder();
    } else {
      _waterReminderTimer = Timer(Duration(milliseconds: remaining), () {
        triggerWaterReminder();
      });
    }
  }

  void triggerWaterReminder() {
    _animationHideTimer?.cancel();
    _showWaterAnimation = true;
    notifyListeners();

    // Auto-hide the animation after 10 seconds
    _animationHideTimer = Timer(const Duration(seconds: 10), () {
      dismissWaterReminder();
    });
  }

  void triggerDemoWaterReminder() {
    _animationHideTimer?.cancel();
    _showWaterAnimation = true;
    notifyListeners();

    _animationHideTimer = Timer(const Duration(seconds: 10), () {
      _showWaterAnimation = false;
      notifyListeners();
    });
  }

  void dismissWaterReminder() {
    _animationHideTimer?.cancel();
    _showWaterAnimation = false;
    notifyListeners();

    if (_settings.waterReminderEnabled) {
      final nextTimestamp = DateTime.now().millisecondsSinceEpoch +
          _settings.waterReminderIntervalSeconds * 1000;
      _settings = _settings.copyWith(nextWaterReminderTimestamp: nextTimestamp);
      _settingsService.save(_settings);

      _startWaterReminderTimer();
    }
  }

  Future<void> update(ClockSettings settings) async {
    _settings = settings;
    _startWaterReminderTimer();
    notifyListeners();
    await Future.wait([
      _settingsService.save(settings),
      _screenService.apply(
        keepScreenAwake: settings.keepScreenAwake,
        fullscreen: settings.fullscreen,
      ),
    ]);
  }

  Future<void> setUse24HourFormat(bool value) =>
      update(_settings.copyWith(use24HourFormat: value));

  Future<void> setShowSeconds(bool value) =>
      update(_settings.copyWith(showSeconds: value));

  Future<void> setShowDate(bool value) =>
      update(_settings.copyWith(showDate: value));

  Future<void> setShowWeekday(bool value) =>
      update(_settings.copyWith(showWeekday: value));

  Future<void> setShowBattery(bool value) =>
      update(_settings.copyWith(showBattery: value));

  Future<void> setThemeId(String value) =>
      update(_settings.copyWith(themeId: value));

  Future<void> setAccentColor(int value) =>
      update(_settings.copyWith(accentColorValue: value));

  Future<void> setAnimationSpeed(double value) =>
      update(_settings.copyWith(animationSpeed: value));

  Future<void> setFontScale(double value) =>
      update(_settings.copyWith(fontScale: value));

  Future<void> setKeepScreenAwake(bool value) =>
      update(_settings.copyWith(keepScreenAwake: value));

  Future<void> setFullscreen(bool value) =>
      update(_settings.copyWith(fullscreen: value));

  Future<void> setWaterReminderEnabled(bool value) {
    if (!value) {
      _showWaterAnimation = false;
      _animationHideTimer?.cancel();
    }
    final nextTimestamp = value
        ? DateTime.now().millisecondsSinceEpoch +
            _settings.waterReminderIntervalSeconds * 1000
        : 0;
    return update(_settings.copyWith(
      waterReminderEnabled: value,
      nextWaterReminderTimestamp: nextTimestamp,
    ));
  }

  Future<void> setWaterReminderIntervalSeconds(int value) {
    final nextTimestamp = _settings.waterReminderEnabled
        ? DateTime.now().millisecondsSinceEpoch + value * 1000
        : 0;
    return update(_settings.copyWith(
      waterReminderIntervalSeconds: value,
      nextWaterReminderTimestamp: nextTimestamp,
    ));
  }

  @override
  void dispose() {
    _waterReminderTimer?.cancel();
    _animationHideTimer?.cancel();
    super.dispose();
  }
}
