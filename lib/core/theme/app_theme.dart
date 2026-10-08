import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.teal,
          onPrimary: AppColors.card,
          surface: AppColors.ground,
          onSurface: AppColors.ink,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.ground,
      fontFamily: AppTextStyles.fontFamily,
    );
  }
}
