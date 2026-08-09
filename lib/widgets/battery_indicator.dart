import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/clock_theme.dart';

class BatteryIndicator extends StatefulWidget {
  const BatteryIndicator({
    super.key,
    required this.theme,
  });

  final ClockTheme theme;

  @override
  State<BatteryIndicator> createState() => _BatteryIndicatorState();
}

class _BatteryIndicatorState extends State<BatteryIndicator> {
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.unknown;
  StreamSubscription<BatteryState>? _subscription;
  Timer? _periodicTimer;

  @override
  void initState() {
    super.initState();
    _updateBatteryInfo();
    _subscription = _battery.onBatteryStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
        _updateBatteryInfo();
      }
    });

    // Check battery level periodically every 30 seconds
    _periodicTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateBatteryInfo();
    });
  }

  Future<void> _updateBatteryInfo() async {
    if (!mounted) return;
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      if (mounted) {
        setState(() {
          _batteryLevel = level;
          _batteryState = state;
        });
      }
    } catch (_) {
      // Fallback or ignore
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCharging = _batteryState == BatteryState.charging;
    final isFull = _batteryState == BatteryState.full;
    final isLow = _batteryLevel <= 20;

    final Color iconColor;
    if (isCharging) {
      iconColor = const Color(0xFF22C55E); // Green for charging
    } else if (isLow) {
      iconColor = const Color(0xFFEF4444); // Red for low battery
    } else {
      iconColor = widget.theme.mutedDigit; // Standard theme color
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: widget.theme.cardTop.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.theme.mutedDigit.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$_batteryLevel%',
            style: GoogleFonts.inter(
              color: widget.theme.mutedDigit,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 8),
          _BatteryIcon(
            level: _batteryLevel,
            color: iconColor,
            isCharging: isCharging || (isFull && _batteryLevel == 100),
          ),
        ],
      ),
    );
  }
}

class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon({
    required this.level,
    required this.color,
    required this.isCharging,
  });

  final int level;
  final Color color;
  final bool isCharging;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 14,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Outer shell boundary
          Container(
            width: 24,
            height: 14,
            decoration: BoxDecoration(
              border: Border.all(
                color: color.withValues(alpha: 0.7),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Battery fill
          Positioned(
            left: 2.5,
            top: 2.5,
            bottom: 2.5,
            child: Container(
              width: ((24 - 5) * (level / 100)).clamp(0.0, 19.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          // Battery terminal cap
          Positioned(
            right: 0,
            top: 4,
            bottom: 4,
            child: Container(
              width: 2.0,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(1),
                  bottomRight: Radius.circular(1),
                ),
              ),
            ),
          ),
          // Charging bolt overlay
          if (isCharging)
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.flash_on,
                  size: 11,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0.5, 0.5),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
