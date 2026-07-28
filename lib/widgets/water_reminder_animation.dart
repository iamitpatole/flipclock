import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class WaterReminderAnimation extends StatefulWidget {
  const WaterReminderAnimation({super.key});

  @override
  State<WaterReminderAnimation> createState() => _WaterReminderAnimationState();
}

class _WaterReminderAnimationState extends State<WaterReminderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final accentColor = settingsProvider.settings.accentColor;

    return Center(
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bouncing Drop Animation Box
              SizedBox(
                height: 150,
                width: 200,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: WaterDropletPainter(
                        progress: _controller.value,
                        accentColor: accentColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Typography
              Text(
                'Hydration Time!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Take a refreshing sip of water\nto stay healthy and focused.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // 10-Second Countdown Progress Indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 4,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: 0.0),
                    duration: const Duration(seconds: 10),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Manual dismiss button
              TextButton(
                onPressed: () {
                  settingsProvider.dismissWaterReminder();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white54,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Dismiss',
                  style: TextStyle(fontSize: 12, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaterDropletPainter extends CustomPainter {
  final double progress;
  final Color accentColor;

  WaterDropletPainter({
    required this.progress,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    const baseRadius = 22.0;

    double dy = 0.0;
    double scaleX = 1.0;
    double scaleY = 1.0;
    double splashProgress = 0.0;

    if (progress < 0.75) {
      // Jump/Fall phase (0.0 to 0.75 of progress)
      final jumpProgress = progress / 0.75;
      
      // Arc formula for height: sin(jumpProgress * pi)
      dy = -85.0 * sin(jumpProgress * pi);

      // Squish/Stretch behavior:
      // When jumping/falling, the drop stretches vertically (scaleY > 1, scaleX < 1)
      final airStretch = sin(jumpProgress * pi);
      scaleY = 1.0 + 0.22 * airStretch;
      scaleX = 1.0 - 0.11 * airStretch;
    } else {
      // Impact/Squish phase (0.75 to 1.0 of progress)
      final squishProgress = (progress - 0.75) / 0.25;
      dy = 0.0;

      // Squishes outwards upon landing (scaleY < 1, scaleX > 1), then returns to 1.0
      final squishAmount = sin(squishProgress * pi);
      scaleY = 1.0 - 0.28 * squishAmount;
      scaleX = 1.0 + 0.28 * squishAmount;

      splashProgress = squishProgress;
    }

    // 1. Draw Ripple/Splash at landing base
    if (splashProgress > 0.0) {
      final splashPaint = Paint()
        ..color = accentColor.withValues(alpha: (1.0 - splashProgress) * 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      final splashWidth = 56.0 * splashProgress;
      final splashHeight = 12.0 * splashProgress;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + baseRadius - 2),
          width: splashWidth,
          height: splashHeight,
        ),
        splashPaint,
      );
    }

    // 2. Draw landing shadow (dynamic size based on height)
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 
        progress < 0.75
            ? (1.0 - (sin((progress / 0.75) * pi)) * 0.65) * 0.35
            : (0.35 + 0.2 * sin(((progress - 0.75) / 0.25) * pi)),
      )
      ..style = PaintingStyle.fill;

    final shadowWidth = baseRadius *
        2.2 *
        scaleX *
        (progress < 0.75 ? (1.0 - 0.45 * sin((progress / 0.75) * pi)) : 1.0);
    const shadowHeight = 5.0;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + baseRadius - 2),
        width: shadowWidth,
        height: shadowHeight,
      ),
      shadowPaint,
    );

    // 3. Draw Water Droplet Path (with translation & scale applied)
    canvas.save();
    canvas.translate(center.dx, center.dy + dy);
    canvas.scale(scaleX, scaleY);

    final dropletPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor.withValues(alpha: 0.85),
          accentColor,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: baseRadius))
      ..style = PaintingStyle.fill;

    final path = Path();
    final peakY = -baseRadius * 1.55;
    path.moveTo(0, peakY);

    // Teardrop curves
    path.cubicTo(
      baseRadius * 0.85,
      peakY * 0.35,
      baseRadius * 1.05,
      baseRadius * 0.45,
      baseRadius,
      baseRadius * 0.9,
    );
    path.arcToPoint(
      Offset(-baseRadius, baseRadius * 0.9),
      radius: const Radius.circular(baseRadius),
      clockwise: true,
    );
    path.cubicTo(
      -baseRadius * 1.05,
      baseRadius * 0.45,
      -baseRadius * 0.85,
      peakY * 0.35,
      0,
      peakY,
    );
    path.close();

    canvas.drawPath(path, dropletPaint);

    // 4. White highlights inside droplet for shiny/liquid look
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final highlightPath = Path();
    highlightPath.moveTo(-baseRadius * 0.3, -baseRadius * 0.7);
    highlightPath.quadraticBezierTo(
      -baseRadius * 0.55,
      -baseRadius * 0.3,
      -baseRadius * 0.55,
      0,
    );
    highlightPath.quadraticBezierTo(
      -baseRadius * 0.35,
      -baseRadius * 0.3,
      -baseRadius * 0.3,
      -baseRadius * 0.7,
    );
    canvas.drawPath(highlightPath, highlightPaint);

    // Top-left reflective dot
    canvas.drawCircle(
      Offset(-baseRadius * 0.38, -baseRadius * 0.85),
      2.2,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WaterDropletPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor;
  }
}
