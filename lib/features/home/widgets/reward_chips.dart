import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/strings/ar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// شارتا السلسلة والنجوم. السلسلة تظهر فقط إن كانت أكبر من صفر.
class RewardChips extends StatelessWidget {
  const RewardChips({super.key, required this.stars, required this.streak});

  final int stars;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        spacing: 8,
        children: [
          if (streak > 0)
            _Chip(
              asset: AppAssets.flame,
              label: ArStrings.streakDays(streak),
              background: AppColors.coralTint,
              foreground: AppColors.coral,
            ),
          _Chip(
            asset: AppAssets.starFilled,
            label: ArStrings.stars(stars),
            background: AppColors.amberTint,
            foreground: AppColors.amberDark,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.asset,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String asset;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          SvgPicture.asset(asset, width: 16, height: 16),
          Text(label, style: AppTextStyles.chip13.copyWith(color: foreground)),
        ],
      ),
    );
  }
}
