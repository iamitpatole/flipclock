import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const _firstLaunchKey = 'rating_first_launch_time';
  static const _openCountKey = 'rating_open_count';
  static const _promptedCountKey = 'rating_prompted_count';
  static const _ratedOrDeclinedKey = 'rating_has_rated_or_declined';
  static const _lastPromptKey = 'rating_last_prompt_time';

  /// Increments launch count and records first launch date if not already recorded.
  /// Should be called exactly once per app session (e.g., in SettingsProvider startup).
  Future<void> trackLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    // Set first launch timestamp if not present
    if (!prefs.containsKey(_firstLaunchKey)) {
      await prefs.setInt(_firstLaunchKey, DateTime.now().millisecondsSinceEpoch);
    }

    // Increment open count
    final openCount = prefs.getInt(_openCountKey) ?? 0;
    await prefs.setInt(_openCountKey, openCount + 1);
  }

  /// Determines if the user should be prompted to rate the app.
  Future<bool> shouldShowRating() async {
    final prefs = await SharedPreferences.getInstance();

    // If already rated or permanently declined, do not prompt.
    final hasRatedOrDeclined = prefs.getBool(_ratedOrDeclinedKey) ?? false;
    if (hasRatedOrDeclined) return false;

    final firstLaunchTime = prefs.getInt(_firstLaunchKey);
    if (firstLaunchTime == null) return false;

    final openCount = prefs.getInt(_openCountKey) ?? 0;
    final promptedCount = prefs.getInt(_promptedCountKey) ?? 0;
    final lastPromptTime = prefs.getInt(_lastPromptKey) ?? 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    final daysSinceFirstLaunch = (now - firstLaunchTime) / (1000 * 60 * 60 * 24);

    // Initial eligibility: at least 5 opens AND 3 days since first launch
    if (promptedCount == 0) {
      return openCount >= 5 && daysSinceFirstLaunch >= 3;
    }

    // Cooldown eligibility for "Remind me later"
    // Allow up to 3 prompts total, with a 3-day cooldown between them.
    if (promptedCount < 3) {
      final daysSinceLastPrompt = (now - lastPromptTime) / (1000 * 60 * 60 * 24);
      return daysSinceLastPrompt >= 3;
    }

    return false;
  }

  /// Mark the user as having rated or permanently declined the prompt.
  Future<void> markRatedOrDeclined() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratedOrDeclinedKey, true);
  }

  /// Record that the prompt was shown (e.g., when clicking "Remind me later").
  /// This increments the prompted count and updates the cooldown timer.
  Future<void> markPrompted() async {
    final prefs = await SharedPreferences.getInstance();
    final promptedCount = prefs.getInt(_promptedCountKey) ?? 0;
    await prefs.setInt(_promptedCountKey, promptedCount + 1);
    await prefs.setInt(_lastPromptKey, DateTime.now().millisecondsSinceEpoch);
  }
}
