import 'package:flutter/material.dart';

abstract final class AppColors {
  // Warm brown & beige palette — no gradients, flat and intentional
  static const Color primary = Color(0xFF4A3428);      // deep coffee brown
  static const Color primaryDark = Color(0xFF2B1B12);  // near-black espresso
  static const Color accent = Color(0xFFA97155);       // warm copper/tan

  static const Color background = Color(0xFFF3E9DC);   // soft beige
  static const Color surface = Color(0xFFFFFBF5);      // warm cream (cards)

  static const Color textPrimary = Color(0xFF2B1B12);
  static const Color textSecondary = Color(0xFF7A6355);

  static const Color divider = Color(0xFFE0D3C2);
  static const Color error = Color(0xFFB3261E);

  static const Color bookmarkActive = accent;
  static const Color bookmarkInactive = Color(0xFFB8A896);

  // static const Color divider = Color(0xFFE5E7EB);
  // static const Color error = Color(0xFFD32F2F);
  static const Color focusColor = Color(0xFF1A73E8);

  static const Color shadow = Color(0x1A2B1B12); // brown-tinted shadow, not black
}