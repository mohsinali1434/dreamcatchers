import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3693e9);
  static const Color primaryDark = Color(0xFF2D92D3);
  static const Color primaryLight = Color(0xFF44CBF1);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1D1E);
  static const Color textSecondary = Color(0xFF757D8A);
  static const Color textMuted = Color(0xFF9AA2AC);
  static const Color border = Color(0xFFE2E8F0);
  static const Color inputBackground = Color(0xFFF5F7FA);
  static const Color likeActive = Color(0xFF2D9CDB);
  static const Color likeInactive = Color(0xFF757D8A);
  static const Color error = Color(0xFFEB5757);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2994A);
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2D92D3), Color(0xFF44CBF1)],
  );
}
