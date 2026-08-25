import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';
import '../providers/settings_provider.dart';
import '../models/clock_theme.dart';
import '../services/rating_service.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final RatingService _ratingService = RatingService();
  int _rating = 0;
  bool _submittedFeedback = false;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleStarTap(int index) {
    setState(() {
      _rating = index;
    });
  }

  Future<void> _submitFeedback() async {
    final feedback = _feedbackController.text.trim();
    // Log the feedback (in a production environment, this would be sent to an API/Analytics)
    debugPrint('Feedback submitted for FlipClock: "$feedback" with rating $_rating');

    await _ratingService.markRatedOrDeclined();
    setState(() {
      _submittedFeedback = true;
    });
  }

  Future<void> _submitPositiveRating() async {
    await _ratingService.markRatedOrDeclined();
    if (mounted) {
      Navigator.of(context).pop();
    }

    final InAppReview inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        // Fallback to store listing if native is not available
        await inAppReview.openStoreListing(appStoreId: 'com.bytekeeperlabs.flipClock');
      }
    } catch (e) {
      debugPrint('Error triggering in app review: $e');
      try {
        await inAppReview.openStoreListing(appStoreId: 'com.bytekeeperlabs.flipClock');
      } catch (ex) {
        debugPrint('Error opening store listing fallback: $ex');
      }
    }
  }

  Future<void> _remindMeLater() async {
    await _ratingService.markPrompted();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _noThanks() async {
    await _ratingService.markRatedOrDeclined();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final theme = settingsProvider.clockTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        width: 320,
        decoration: BoxDecoration(
          color: theme.cardTop,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.mutedDigit.withValues(alpha: 0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: theme.shadow.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            if (theme.glow != null)
              BoxShadow(
                color: theme.glow!.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top structural split (aesthetic decoration mimicking mechanical flap clock digit splits)
              _buildTopSplitLine(theme),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildDialogContent(theme),
                ),
              ),

              // Bottom structural split
              _buildBottomSplitLine(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSplitLine(ClockTheme theme) {
    return Container(
      height: 4,
      width: double.infinity,
      color: theme.cardBottom,
    );
  }

  Widget _buildBottomSplitLine(ClockTheme theme) {
    return Container(
      height: 8,
      width: double.infinity,
      color: theme.cardBottom.withValues(alpha: 0.6),
    );
  }

  Widget _buildDialogContent(ClockTheme theme) {
    if (_submittedFeedback) {
      return Column(
        key: const ValueKey('feedback_submitted'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: theme.accent, size: 48),
          const SizedBox(height: 16),
          Text(
            'Thank You!',
            style: TextStyle(
              color: theme.digit,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your feedback helps us make Flip Clock better. We truly appreciate you taking the time to share it with us!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.mutedDigit,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextButton(
            text: 'Close',
            onPressed: () => Navigator.of(context).pop(),
            theme: theme,
            isPrimary: true,
          ),
        ],
      );
    }

    if (_rating == 0) {
      return Column(
        key: const ValueKey('rating_selection'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.star_rounded, color: theme.accent, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Enjoying Flip Clock?',
            style: TextStyle(
              color: theme.digit,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'How would you rate your experience so far? Tap a star to tell us!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.mutedDigit,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _buildStarsRow(theme),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextButton(
                  text: 'No, thanks',
                  onPressed: _noThanks,
                  theme: theme,
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextButton(
                  text: 'Remind later',
                  onPressed: _remindMeLater,
                  theme: theme,
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (_rating >= 4) {
      return Column(
        key: const ValueKey('rating_positive'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_rounded, color: theme.accent, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'We love that!',
            style: TextStyle(
              color: theme.digit,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Would you mind leaving a review on the store? It only takes a minute and helps us support the app!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.mutedDigit,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          _buildStarsRow(theme),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextButton(
                  text: 'No, thanks',
                  onPressed: _noThanks,
                  theme: theme,
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextButton(
                  text: 'Rate Now',
                  onPressed: _submitPositiveRating,
                  theme: theme,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Rating 1 to 3
    return Column(
      key: const ValueKey('rating_negative'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            'How can we improve?',
            style: TextStyle(
              color: theme.digit,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'We value your feedback. Let us know how we can make Flip Clock better for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.mutedDigit,
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(child: _buildStarsRow(theme)),
        const SizedBox(height: 16),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          style: TextStyle(color: theme.digit, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Share your suggestions...',
            hintStyle: TextStyle(color: theme.mutedDigit.withValues(alpha: 0.5), fontSize: 14),
            fillColor: theme.cardBottom,
            filled: true,
            contentPadding: const EdgeInsets.all(12),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.accent, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.mutedDigit.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextButton(
                text: 'Cancel',
                onPressed: () => setState(() => _rating = 0),
                theme: theme,
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextButton(
                text: 'Submit',
                onPressed: _submitFeedback,
                theme: theme,
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStarsRow(ClockTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= _rating;
        return IconButton(
          icon: Icon(
            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isSelected ? theme.accent : theme.mutedDigit.withValues(alpha: 0.4),
            size: 32,
          ),
          onPressed: () => _handleStarTap(starIndex),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(),
        );
      }),
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback onPressed,
    required ClockTheme theme,
    required bool isPrimary,
  }) {
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isPrimary ? theme.accent : theme.cardBottom,
          foregroundColor: isPrimary
              ? (theme.isLight ? Colors.black : Colors.white)
              : theme.digit,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: theme.mutedDigit.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
