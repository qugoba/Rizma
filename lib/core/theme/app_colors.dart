import 'package:flutter/painting.dart';

/// ألوان التصميم كما هي في Figma (Color/*).
abstract final class AppColors {
  // الخلفيات والأسطح
  static const ground = Color(0xFFF4F5F1);
  static const light = Color(0xFFF4F1E8);
  static const card = Color(0xFFFFFFFF);
  static const mute = Color(0xFFE6EAE5);
  static const line = Color(0xFFE1E6E2);
  static const disabled = Color(0xFFC9D2CD);

  // النصوص
  static const ink = Color(0xFF0F2A2E);
  static const soft = Color(0xFF55655F);

  // الأخضر (اللون الأساسي)
  static const teal = Color(0xFF177A63);
  static const tealDark = Color(0xFF0E5C4A);
  static const tealTint = Color(0xFFDCEFE6);
  static const onTeal = Color(0xFFD5EEE3);

  // العنبري
  static const amber = Color(0xFFE9A23B);
  static const amberDark = Color(0xFF8F540A);
  static const amberTint = Color(0xFFFCEFD6);
  static const amberLine = Color(0xFFF1D29C);

  // الأزرق
  static const blue = Color(0xFF2F66C9);
  static const blueTint = Color(0xFFDEE7F8);

  // المرجاني
  static const coral = Color(0xFFB94F2A);
  static const coralTint = Color(0xFFF8E1D7);

  // البنفسجي
  static const purple = Color(0xFF6A4FB3);
  static const purpleTint = Color(0xFFE9E3F6);
}
