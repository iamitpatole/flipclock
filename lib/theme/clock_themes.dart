import 'package:flutter/material.dart';

import '../models/clock_theme.dart';

class ClockThemes {
  const ClockThemes._();

  static const List<ClockTheme> all = [
    ClockTheme(
      id: 'classic_black',
      name: 'Classic Black',
      background: Color(0xFF050505),
      cardTop: Color(0xFF171717),
      cardBottom: Color(0xFF0E0E0E),
      digit: Color(0xFFF8FAFC),
      mutedDigit: Color(0xFF94A3B8),
      accent: Color(0xFF38BDF8),
      shadow: Color(0xCC000000),
      glow: Color(0x2938BDF8),
    ),
    ClockTheme(
      id: 'retro_brown',
      name: 'Retro Brown',
      background: Color(0xFF24160F),
      cardTop: Color(0xFF4A2F20),
      cardBottom: Color(0xFF332014),
      digit: Color(0xFFFFE8B6),
      mutedDigit: Color(0xFFD8B98B),
      accent: Color(0xFFFFB86B),
      shadow: Color(0xAA000000),
      glow: Color(0x24FFB86B),
    ),
    ClockTheme(
      id: 'oled',
      name: 'OLED',
      background: Color(0xFF000000),
      cardTop: Color(0xFF070707),
      cardBottom: Color(0xFF020202),
      digit: Color(0xFFFFFFFF),
      mutedDigit: Color(0xFFB6C2CF),
      accent: Color(0xFFFFFFFF),
      shadow: Color(0xF2000000),
      glow: Color(0x22FFFFFF),
    ),
    ClockTheme(
      id: 'blue_neon',
      name: 'Blue Neon',
      background: Color(0xFF03111F),
      cardTop: Color(0xFF09223C),
      cardBottom: Color(0xFF06182B),
      digit: Color(0xFF67E8F9),
      mutedDigit: Color(0xFF7DD3FC),
      accent: Color(0xFF22D3EE),
      shadow: Color(0xCC000814),
      glow: Color(0x3D22D3EE),
    ),
    ClockTheme(
      id: 'green_terminal',
      name: 'Green Terminal',
      background: Color(0xFF020403),
      cardTop: Color(0xFF07140C),
      cardBottom: Color(0xFF030B06),
      digit: Color(0xFF5CFF8F),
      mutedDigit: Color(0xFF86E8A1),
      accent: Color(0xFF22C55E),
      shadow: Color(0xDD000000),
      glow: Color(0x3322C55E),
    ),
    ClockTheme(
      id: 'minimal_white',
      name: 'Minimal White',
      background: Color(0xFFF8FAFC),
      cardTop: Color(0xFFFFFFFF),
      cardBottom: Color(0xFFE8EEF5),
      digit: Color(0xFF0F172A),
      mutedDigit: Color(0xFF475569),
      accent: Color(0xFF2563EB),
      shadow: Color(0x330F172A),
      glow: Color(0x1A2563EB),
    ),
  ];

  static ClockTheme byId(String id) {
    return all.firstWhere((theme) => theme.id == id, orElse: () => all.first);
  }
}
