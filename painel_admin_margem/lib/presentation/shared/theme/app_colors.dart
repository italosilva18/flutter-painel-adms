import 'package:flutter/material.dart';

/// Classe que contém todas as cores utilizadas no aplicativo
class AppColors {
  static const Color primary = Color(0xFF2C71B6);
  static const Color secondary = Color(0xFF3C649A);
  static const Color tertiary = Color(0xFF0E397E);
  static const Color quaternary = Color(0xFF421E6B);
  static const Color accent = Color(0xFF991A66);
  static const Color accentSecondary = Color(0xFFB23B59);
  static const Color accentTertiary = Color(0xFFCA5B4B);
  static const Color accentQuaternary = Color(0xFFF7BC5E);

  // Cores de texto
  static const Color textPrimary = Color(0xFF2F373A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF888888);

  // Cores de background
  static const Color background = Colors.white;
  static const Color backgroundLight = Color(0xFFFAFAFB);
  static const Color backgroundGrey = Color(0xFFF3F3F3);

  // Cores de borda
  static const Color border = Color(0xFFA9ACAD);
  static const Color borderLight = Color(0xFF818E94);

  // Cores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Cores de sombra
  static const Color shadow = Color(0x14444444);

  // Gradiente do botão principal
  static const List<Color> primaryGradient = [
    Color(0xFF46A29D),
    Color(0xFF3C649A),
    Color(0xFF0E397E),
    Color(0xFF421E6B),
    Color(0xFF991A66),
    Color(0xFFB23B59),
    Color(0xFFCA5B4B),
    Color(0xFFF7BC5E),
  ];

  // Gradiente da borda de menu ativo
  static const List<Color> menuActiveBorderGradient = primaryGradient;
}
