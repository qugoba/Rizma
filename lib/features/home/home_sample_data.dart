import 'package:flutter/painting.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';

/// بيانات تجريبية مأخوذة من التصميم — تُستبدل بالبيانات الحقيقية عند ربط الخلفية.
abstract final class HomeSampleData {
  static const stars = 24;
  static const streakDays = 5;

  static const currentSubject = 'الرياضيات · الوحدة الثالثة';
  static const currentLesson = 'الدرس 3: الكسور المتكافئة';
  static const currentProgress = 0.75;

  static const reviewTopic = 'الكسور المتكافئة';
  static const reviewDetails = 'الإتقان 40% · خطة من 4 خطوات';

  static const challengeSubtitle = '5 أسئلة سريعة · حتى 15 نجمة';

  static const subjects = [
    SubjectSummary(
      name: 'الرياضيات',
      iconAsset: AppAssets.calcSubject,
      tileColor: AppColors.tealTint,
      accent: AppColors.teal,
      progress: 0.80,
    ),
    SubjectSummary(
      name: 'العربية',
      iconAsset: AppAssets.bookSubject,
      tileColor: AppColors.coralTint,
      accent: AppColors.coral,
      progress: 0.75,
    ),
    SubjectSummary(
      name: 'الإنجليزية',
      iconAsset: AppAssets.chat,
      tileColor: AppColors.purpleTint,
      accent: AppColors.purple,
      progress: 0.70,
    ),
    SubjectSummary(
      name: 'العلوم',
      iconAsset: AppAssets.leaf,
      tileColor: AppColors.blueTint,
      accent: AppColors.blue,
      progress: 0.65,
    ),
  ];
}

class SubjectSummary {
  const SubjectSummary({
    required this.name,
    required this.iconAsset,
    required this.tileColor,
    required this.accent,
    required this.progress,
  });

  final String name;
  final String iconAsset;
  final Color tileColor;
  final Color accent;
  final double progress;

  String get percentLabel => '${(progress * 100).round()}%';
}
