import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:in_app_review/in_app_review.dart';
import '../providers/settings_provider.dart';
import '../services/app_info_service.dart';
import '../theme/clock_themes.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _accentColors = [
    Color(0xFF38BDF8),
    Color(0xFFFFB86B),
    Color(0xFF22C55E),
    Color(0xFFEF4444),
    Color(0xFFA78BFA),
    Color(0xFFF8FAFC),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          SettingsSection(
            title: 'Clock',
            children: [
              SettingsSwitchTile(
                icon: Icons.schedule,
                title: '24-hour mode',
                subtitle: 'Use 00-23 hours instead of AM/PM.',
                value: settings.use24HourFormat,
                onChanged: provider.setUse24HourFormat,
              ),
              SettingsSwitchTile(
                icon: Icons.timer_outlined,
                title: 'Show seconds',
                subtitle: 'Animate the seconds cards every tick.',
                value: settings.showSeconds,
                onChanged: provider.setShowSeconds,
              ),
              SettingsSwitchTile(
                icon: Icons.today_outlined,
                title: 'Show date',
                subtitle: 'Display the current month, day, and year.',
                value: settings.showDate,
                onChanged: provider.setShowDate,
              ),
              SettingsSwitchTile(
                icon: Icons.calendar_view_week_outlined,
                title: 'Show weekday',
                subtitle: 'Display the day of the week above the clock.',
                value: settings.showWeekday,
                onChanged: provider.setShowWeekday,
              ),
              SettingsSwitchTile(
                icon: Icons.battery_charging_full_outlined,
                title: 'Show battery',
                subtitle: 'Display battery percentage and charging state.',
                value: settings.showBattery,
                onChanged: provider.setShowBattery,
              ),
            ],
          ),
          SettingsSection(
            title: 'Appearance',
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: Text(provider.clockTheme.name),
                trailing: DropdownButton<String>(
                  value: settings.themeId,
                  onChanged: (value) {
                    if (value != null) {
                      provider.setThemeId(value);
                    }
                  },
                  items: [
                    for (final theme in ClockThemes.all)
                      DropdownMenuItem(
                        value: theme.id,
                        child: Text(theme.name),
                      ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Accent color'),
                subtitle: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final color in _accentColors)
                      _AccentSwatch(
                        color: color,
                        selected: color.toARGB32() == settings.accentColorValue,
                        onTap: () => provider.setAccentColor(color.toARGB32()),
                      ),
                  ],
                ),
              ),
              SettingsSliderTile(
                icon: Icons.format_size,
                title: 'Font size',
                subtitle: 'Scale the flip-card digits.',
                value: settings.fontScale,
                min: 0.85,
                max: 1.2,
                divisions: 7,
                onChanged: provider.setFontScale,
              ),
            ],
          ),
          SettingsSection(
            title: 'Behavior',
            children: [
              SettingsSliderTile(
                icon: Icons.speed,
                title: 'Animation speed',
                subtitle: 'Adjust the mechanical flip timing.',
                value: settings.animationSpeed,
                min: 0.65,
                max: 1.6,
                divisions: 19,
                onChanged: provider.setAnimationSpeed,
              ),
              SettingsSwitchTile(
                icon: Icons.lightbulb_outline,
                title: 'Keep screen awake',
                subtitle: 'Prevent the display from sleeping while open.',
                value: settings.keepScreenAwake,
                onChanged: provider.setKeepScreenAwake,
              ),
              SettingsSwitchTile(
                icon: Icons.fullscreen,
                title: 'Fullscreen mode',
                subtitle: 'Hide system bars for a screensaver feel.',
                value: settings.fullscreen,
                onChanged: provider.setFullscreen,
              ),
            ],
          ),
          SettingsSection(
            title: 'Water Reminder',
            children: [
              SettingsSwitchTile(
                icon: Icons.water_drop_outlined,
                title: 'Water reminder',
                subtitle: 'Get reminded to drink water at regular intervals.',
                value: settings.waterReminderEnabled,
                onChanged: provider.setWaterReminderEnabled,
              ),
              if (settings.waterReminderEnabled) ...[
                ListTile(
                  leading: const Icon(Icons.av_timer_outlined),
                  title: const Text('Reminder interval'),
                  subtitle: const Text('How often to show the reminder.'),
                  trailing: DropdownButton<int>(
                    value:
                        [
                          3600,
                          7200,
                          10800,
                          14400,
                        ].contains(settings.waterReminderIntervalSeconds)
                        ? settings.waterReminderIntervalSeconds
                        : 3600,
                    onChanged: (value) {
                      if (value != null) {
                        provider.setWaterReminderIntervalSeconds(value);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 3600, child: Text('1 hour')),
                      DropdownMenuItem(value: 7200, child: Text('2 hours')),
                      DropdownMenuItem(value: 10800, child: Text('3 hours')),
                      DropdownMenuItem(value: 14400, child: Text('4 hours')),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SettingsSection(
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rate the app'),
                subtitle: const Text('Rate us on the Play Store.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  try {
                    await InAppReview.instance.openStoreListing(
                      appStoreId: 'com.bytekeeperlabs.flipClock',
                    );
                  } catch (e) {
                    debugPrint('Error opening store listing: $e');
                  }
                },
              ),
              const _AppVersionTile(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppVersionTile extends StatefulWidget {
  const _AppVersionTile();

  @override
  State<_AppVersionTile> createState() => _AppVersionTileState();
}

class _AppVersionTileState extends State<_AppVersionTile> {
  late final Future<String> _versionFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = const AppInfoService().getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _versionFuture,
      builder: (context, snapshot) {
        final versionText =
            snapshot.data ?? (snapshot.hasError ? '1.0.0' : 'Loading...');
        return ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Version'),
          subtitle: Text(versionText),
        );
      },
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Accent color',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}
