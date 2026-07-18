import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/clock_theme.dart';
import 'flip_card.dart';

class FlipDigit extends StatefulWidget {
  const FlipDigit({
    super.key,
    required this.value,
    required this.width,
    required this.height,
    required this.theme,
    required this.duration,
    required this.fontSize,
  });

  final String value;
  final double width;
  final double height;
  final ClockTheme theme;
  final Duration duration;
  final double fontSize;

  @override
  State<FlipDigit> createState() => _FlipDigitState();
}

class _FlipDigitState extends State<FlipDigit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late String _previousValue;
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _currentValue = widget.value;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  void didUpdateWidget(covariant FlipDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (widget.value != _currentValue) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final progress = _animation.value;
          if (!_controller.isAnimating) {
            return FlipCard(
              value: _currentValue,
              width: widget.width,
              height: widget.height,
              theme: widget.theme,
              fontSize: widget.fontSize,
            );
          }

          return Stack(
            children: [
              FlipCard(
                value: progress < 0.5 ? _previousValue : _currentValue,
                width: widget.width,
                height: widget.height,
                theme: widget.theme,
                fontSize: widget.fontSize,
              ),
              if (progress < 0.5)
                _FlipHalf(
                  value: _previousValue,
                  width: widget.width,
                  height: widget.height,
                  theme: widget.theme,
                  fontSize: widget.fontSize,
                  half: CardHalf.top,
                  angle: _lerp(0, math.pi / 2, progress * 2),
                  alignment: Alignment.bottomCenter,
                  shadowOpacity: _lerp(0.08, 0.52, progress * 2),
                )
              else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _FlipHalf(
                    value: _currentValue,
                    width: widget.width,
                    height: widget.height,
                    theme: widget.theme,
                    fontSize: widget.fontSize,
                    half: CardHalf.bottom,
                    angle: _lerp(-math.pi / 2, 0, (progress - 0.5) * 2),
                    alignment: Alignment.topCenter,
                    shadowOpacity: _lerp(0.5, 0.02, (progress - 0.5) * 2),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FlipHalf extends StatelessWidget {
  const _FlipHalf({
    required this.value,
    required this.width,
    required this.height,
    required this.theme,
    required this.fontSize,
    required this.half,
    required this.angle,
    required this.alignment,
    required this.shadowOpacity,
  });

  final String value;
  final double width;
  final double height;
  final ClockTheme theme;
  final double fontSize;
  final CardHalf half;
  final double angle;
  final Alignment alignment;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0018)
        ..rotateX(angle),
      child: SizedBox(
        width: width,
        height: height / 2,
        child: CardFaceHalf(
          value: value,
          width: width,
          height: height,
          theme: theme,
          fontSize: fontSize,
          half: half,
          shadowOpacity: shadowOpacity,
        ),
      ),
    );
  }
}

double _lerp(double start, double end, double progress) {
  return start + (end - start) * progress.clamp(0, 1);
}
