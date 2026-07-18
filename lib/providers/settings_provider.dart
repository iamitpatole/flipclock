import 'package:flutter/foundation.dart';

import '../models/clock_settings.dart';
import '../models/clock_theme.dart';
import '../services/screen_service.dart';
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

  Future<void> _load() async {
    _settings = await _settingsService.load();
    _isLoaded = true;
    await _screenService.apply(
      keepScreenAwake: _settings.keepScreenAwake,
      fullscreen: _settings.fullscreen,
    );
    notifyListeners();
  }

  Future<void> update(ClockSettings settings) async {
    _settings = settings;
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
}
