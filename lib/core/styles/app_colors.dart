import 'package:flutter/material.dart';

class AppColors {
  // Primary colors (from design tokens)
  static const primary = Color(0xFF0A4D68);
  static const accent = Color(0xFF2E7D8C);
  static const accentLight = Color(0xFF3A9FB0);
  static const iconBg = Color(0xFF3A7CA5);
  static const white = Colors.white;
  static const redAlert = Colors.redAccent;
  static const orange = Colors.orangeAccent;
  static const yellow = Colors.yellow;
  static const shadow = Colors.black12;
  static const brown = Colors.brown;
  static const grey = Colors.grey;
  static final lightGrey = Colors.grey[300]!;
  static const lightGreen = Colors.lightGreen;

  // Dark theme colors for POS style (from design tokens)
  static const darkBackground = Color(0xFF1E1E1E);
  static const cardDark = Color(0xFF2D2D2D);
  static const bgSecondary = Color(0xFF2A2A2A);
  static const bgInput = Color(0xFF3A3A3A);
  static const cardBrown = Color(0xFF4A3428);
  static const cardBlue = Color(0xFF1E3A5F);
  static const cardGold = Color(0xFF5C5324);
  static const border = Color(0xFF404040);

  // Text colors (from design tokens)
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9E9E9E);
  static const textMuted = Color(0xFF6B6B6B);
  static const textLight = Color(0xFFE0E0E0);
  static const dividerColor = Color(0xFF3A3A3A);

  // Status badges
  static const badgePending = Color(0xFFFF9800);
  static const badgePaid = Color(0xFF4CAF50);

  // Action buttons
  static const cancelRed = Color(0xFFE57373);

  // Alert "ya pagado" (dark theme version from design)
  static const alertPaidBg = Color(0xFF3D3000);
  static const alertPaidBorder = Color(0xFFB8860B);
  static const alertPaidText = Color(0xFFFF9800);
}
