import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/clock_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/clock_face.dart';
import '../widgets/water_reminder_animation.dart';
import '../widgets/battery_indicator.dart';
import 'settings_screen.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;
    final clockTheme = settingsProvider.clockTheme;
    final now = context.select<ClockProvider, DateTime>(
      (provider) => provider.now,
    );

    return AnimatedTheme(
      data: Theme.of(context),
      duration: const Duration(milliseconds: 350),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          color: Colors.black,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClockFace(
                    now: now,
                    settings: settings,
                    theme: clockTheme,
                  ),
                ),
                if (settings.showBattery)
                  Positioned(
                    top: 10,
                    left: 16,
                    child: BatteryIndicator(theme: clockTheme),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FullscreenButton(
                        themeColor: clockTheme.mutedDigit,
                        isFullscreen: settings.fullscreen,
                        onPressed: () =>
                            settingsProvider.setFullscreen(!settings.fullscreen),
                      ),
                      const SizedBox(width: 8),
                      _SettingsButton(themeColor: clockTheme.mutedDigit),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    reverseDuration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                              reverseCurve: Curves.easeInCubic,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: settingsProvider.showWaterAnimation
                        ? const WaterReminderAnimation()
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.themeColor});

  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Settings',
      child: IconButton.filledTonal(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
          );
        },
        icon: Icon(Icons.tune, color: themeColor),
      ),
    );
  }
}

class _FullscreenButton extends StatelessWidget {
  const _FullscreenButton({
    required this.themeColor,
    required this.isFullscreen,
    required this.onPressed,
  });

  final Color themeColor;
  final bool isFullscreen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isFullscreen ? 'Exit Fullscreen' : 'Enter Fullscreen',
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(
          isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
          color: themeColor,
        ),
      ),
    );
  }
}
