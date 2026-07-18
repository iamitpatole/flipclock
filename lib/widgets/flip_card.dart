import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/clock_theme.dart';

enum CardHalf { top, bottom }

class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.value,
    required this.width,
    required this.height,
    required this.theme,
    required this.fontSize,
    this.opacity = 1,
  });

  final String value;
  final double width;
  final double height;
  final ClockTheme theme;
  final double fontSize;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: value,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: theme.shadow,
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            _CardHalf(
              value: value,
              width: width,
              height: height,
              theme: theme,
              fontSize: fontSize,
              half: CardHalf.top,
              opacity: opacity,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _CardHalf(
                value: value,
                width: width,
                height: height,
                theme: theme,
                fontSize: fontSize,
                half: CardHalf.bottom,
                opacity: opacity,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: height / 2 - 0.5,
              child: Container(
                height: 1,
                color: Colors.black.withValues(
                  alpha: theme.isLight ? 0.12 : 0.42,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardFaceHalf extends StatelessWidget {
  const CardFaceHalf({
    super.key,
    required this.value,
    required this.width,
    required this.height,
    required this.theme,
    required this.fontSize,
    required this.half,
    this.shadowOpacity = 0,
  });

  final String value;
  final double width;
  final double height;
  final ClockTheme theme;
  final double fontSize;
  final CardHalf half;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CardHalf(
          value: value,
          width: width,
          height: height,
          theme: theme,
          fontSize: fontSize,
          half: half,
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: shadowOpacity),
              borderRadius: _radiusForHalf(half),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardHalf extends StatelessWidget {
  const _CardHalf({
    required this.value,
    required this.width,
    required this.height,
    required this.theme,
    required this.fontSize,
    required this.half,
    this.opacity = 1,
  });

  final String value;
  final double width;
  final double height;
  final ClockTheme theme;
  final double fontSize;
  final CardHalf half;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final isTop = half == CardHalf.top;
    return ClipRRect(
      borderRadius: _radiusForHalf(half),
      child: SizedBox(
        width: width,
        height: height / 2,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
                  end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
                  colors: [
                    (isTop ? theme.cardTop : theme.cardBottom).withValues(
                      alpha: opacity,
                    ),
                    (isTop ? theme.cardBottom : theme.cardTop).withValues(
                      alpha: opacity * 0.92,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: isTop ? 0 : -height / 2,
              left: 0,
              child: SizedBox(
                width: width,
                height: height,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: GoogleFonts.rajdhani(
                      color: theme.digit.withValues(alpha: opacity),
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: 0,
                      shadows: [
                        Shadow(
                          color: theme.glow ?? Colors.transparent,
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!isTop)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(
                    alpha: theme.isLight ? 0.4 : 0.08,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

BorderRadius _radiusForHalf(CardHalf half) {
  const radius = Radius.circular(10);
  return half == CardHalf.top
      ? const BorderRadius.vertical(top: radius)
      : const BorderRadius.vertical(bottom: radius);
}
