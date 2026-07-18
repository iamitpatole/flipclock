# FlipClock

FlipClock is a polished Flutter flip-clock application inspired by classic mechanical desk clocks. It displays hours, minutes, seconds, the current date, and weekday with custom perspective flip animations.

## Features

- Realistic custom flip-card animation with top and bottom half rotation
- 12-hour and 24-hour modes
- Optional seconds, date, and weekday display
- Built-in themes: Classic Black, Retro Brown, OLED, Blue Neon, Green Terminal, and Minimal White
- Accent color, animation speed, and digit scale controls
- Keep-screen-awake and fullscreen settings
- SharedPreferences persistence
- Provider-based state management
- Responsive layout for phones, tablets, desktop, portrait, and landscape
- Accessibility-friendly labels and high-contrast themes

## Project Structure

```text
lib/
  app/        App composition and provider setup
  core/       Reserved for cross-cutting primitives
  models/     Settings and theme data models
  providers/  Provider state objects
  screens/    Clock and settings screens
  services/   Clock, screen, and settings services
  theme/      Built-in theme definitions
  utils/      Time formatting and responsive sizing helpers
  widgets/    Reusable clock, flip-card, date, and settings widgets
```

## Running

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
dart format .
flutter analyze
flutter test
```


flutter build appbundle --release

flutter build apk --release