import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/strings/ar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/dashed_border.dart';
import '../../../core/widgets/icon_tile.dart';
import '../home_state.dart';

/// بدل المراجعة قبل أول اختبار: صندوق منقّط يشرح متى ستظهر.
class ReviewPlaceholder extends StatelessWidget {
  const ReviewPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return DashedBorderBox(
      color: AppColors.disabled,
      radius: 18,
      dash: 6,
      gap: 5,
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
      child: Row(
        spacing: 12,
        children: [
          const IconTile(
            iconData: Icons.warning_amber_rounded,
            iconColor: AppColors.soft,
            color: AppColors.mute,
            size: 40,
            iconSize: 20,
            radius: 12,
          ),
          Expanded(
            child: Text(
              ArStrings.homeReviewPlaceholder,
              style: AppTextStyles.label14,
            ),
          ),
        ],
      ),
    );
  }
}

/// «يحتاج إلى مراجعة»: بطاقة لكل مفهوم إتقانه منخفض.
class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key, required this.items, required this.onReview});

  final List<ReviewItem> items;
  final ValueChanged<ReviewItem> onReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(ArStrings.homeNeedsReview, style: AppTextStyles.section18),
        for (final item in items)
          _ReviewCard(item: item, onTap: () => onReview(item)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.item, required this.onTap});

  final ReviewItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percent = (item.mastery * 100).round();

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.amberTint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.amberLine),
      ),
      child: Row(
        spacing: 12,
        children: [
          const IconTile(
            asset: AppAssets.warn,
            color: AppColors.amberLine,
            size: 44,
            iconSize: 22,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.concept.title, style: AppTextStyles.body16Strong),
                Text(
                  ArStrings.homeMastery(percent),
                  style: AppTextStyles.captionBold13.copyWith(
                    color: AppColors.amberDark,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.amberDark,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                child: Text(
                  ArStrings.homeReviewButton,
                  style: AppTextStyles.label14.copyWith(color: AppColors.card),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
