import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/clock_provider.dart';
import '../providers/settings_provider.dart';
import '../screens/clock_screen.dart';
import '../services/clock_service.dart';
import '../services/screen_service.dart';
import '../services/settings_service.dart';

class FlipClockApp extends StatelessWidget {
  const FlipClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClockProvider(ClockService())),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(SettingsService(), ScreenService()),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          final accent = settingsProvider.settings.accentColor;
          final colorScheme = ColorScheme.fromSeed(
            seedColor: accent,
            brightness: Brightness.dark,
          );

          return MaterialApp(
            title: 'FlipClock',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              colorScheme: colorScheme.copyWith(primary: accent),
              textTheme: ThemeData(brightness: Brightness.dark).textTheme,
            ),
            home: const ClockScreen(),
          );
        },
      ),
    );
  }
}
