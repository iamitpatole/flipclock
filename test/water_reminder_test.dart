import 'package:flutter_test/flutter_test.dart';
import 'package:flip_clock/models/clock_settings.dart';
import 'package:flip_clock/providers/settings_provider.dart';
import 'package:flip_clock/services/screen_service.dart';
import 'package:flip_clock/services/settings_service.dart';

class FakeSettingsService extends SettingsService {
  ClockSettings _settings = const ClockSettings();

  @override
  Future<ClockSettings> load() async => _settings;

  @override
  Future<void> save(ClockSettings settings) async {
    _settings = settings;
  }
}

class FakeScreenService extends ScreenService {
  bool keepScreenAwakeApplied = false;
  bool fullscreenApplied = false;

  @override
  Future<void> apply({required bool keepScreenAwake, required bool fullscreen}) async {
    keepScreenAwakeApplied = keepScreenAwake;
    fullscreenApplied = fullscreen;
  }
}

void main() {
  group('Water Reminder Settings & Timer Tests', () {
    late FakeSettingsService fakeSettingsService;
    late FakeScreenService fakeScreenService;
    late SettingsProvider settingsProvider;

    setUp(() async {
      fakeSettingsService = FakeSettingsService();
      fakeScreenService = FakeScreenService();
      settingsProvider = SettingsProvider(fakeSettingsService, fakeScreenService);
      // Wait for provider to load initial settings
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('Default values for water reminder are correct', () {
      expect(settingsProvider.settings.waterReminderEnabled, isFalse);
      expect(settingsProvider.settings.waterReminderIntervalSeconds, equals(3600));
      expect(settingsProvider.settings.nextWaterReminderTimestamp, equals(0));
      expect(settingsProvider.showWaterAnimation, isFalse);
    });

    test('Enabling water reminder sets next trigger timestamp', () async {
      final beforeTime = DateTime.now().millisecondsSinceEpoch;
      await settingsProvider.setWaterReminderEnabled(true);

      expect(settingsProvider.settings.waterReminderEnabled, isTrue);
      expect(settingsProvider.settings.nextWaterReminderTimestamp, greaterThan(0));

      final expectedTriggerTime = beforeTime + settingsProvider.settings.waterReminderIntervalSeconds * 1000;
      // Allow minor timing discrepancy
      expect(
        (settingsProvider.settings.nextWaterReminderTimestamp - expectedTriggerTime).abs(),
        lessThan(500),
      );
    });

    test('Changing interval calculates new reminder timestamp if enabled', () async {
      await settingsProvider.setWaterReminderEnabled(true);
      final firstTimestamp = settingsProvider.settings.nextWaterReminderTimestamp;

      // Update to 10 seconds interval
      await settingsProvider.setWaterReminderIntervalSeconds(10);
      expect(settingsProvider.settings.waterReminderIntervalSeconds, equals(10));
      
      final secondTimestamp = settingsProvider.settings.nextWaterReminderTimestamp;
      expect(secondTimestamp, isNot(equals(firstTimestamp)));
      expect(
        (secondTimestamp - (DateTime.now().millisecondsSinceEpoch + 10 * 1000)).abs(),
        lessThan(500),
      );
    });

    test('Triggering demo animation updates showWaterAnimation state', () {
      expect(settingsProvider.showWaterAnimation, isFalse);

      settingsProvider.triggerDemoWaterReminder();
      expect(settingsProvider.showWaterAnimation, isTrue);

      settingsProvider.dismissWaterReminder();
      expect(settingsProvider.showWaterAnimation, isFalse);
    });

    test('Triggering reminder advances next timestamp and shows animation on dismiss', () async {
      await settingsProvider.setWaterReminderEnabled(true);
      final initialTimestamp = settingsProvider.settings.nextWaterReminderTimestamp;

      // Wait a short duration to ensure DateTime.now() advances
      await Future<void>.delayed(const Duration(milliseconds: 5));

      settingsProvider.triggerWaterReminder();
      expect(settingsProvider.showWaterAnimation, isTrue);
      // Under new logic, triggering reminder doesn't change next timestamp immediately
      expect(settingsProvider.settings.nextWaterReminderTimestamp, equals(initialTimestamp));

      // Dismissing the reminder should advance the next timestamp
      settingsProvider.dismissWaterReminder();
      expect(settingsProvider.showWaterAnimation, isFalse);

      final nextTimestamp = settingsProvider.settings.nextWaterReminderTimestamp;
      expect(nextTimestamp, greaterThan(initialTimestamp));
      
      final expectedNextTime = DateTime.now().millisecondsSinceEpoch + settingsProvider.settings.waterReminderIntervalSeconds * 1000;
      expect(
        (nextTimestamp - expectedNextTime).abs(),
        lessThan(500),
      );
    });
  });
}
