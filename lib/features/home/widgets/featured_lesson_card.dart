import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/strings/ar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../catalog/subject_visuals.dart';
import '../home_state.dart';

/// البطاقة الخضراء: «ابدأ أول درس» في أول يوم، أو «متابعة التعلم» بعد ذلك.
class FeaturedLessonCard extends StatelessWidget {
  const FeaturedLessonCard({
    super.key,
    required this.lesson,
    required this.firstDay,
    required this.onPressed,
  });

  final LessonRef lesson;
  final bool firstDay;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final percent = (lesson.progress * 100).round();

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            spacing: 8,
            children: [
              SvgPicture.asset(
                subjectIconAsset(lesson.subject.icon),
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.onTeal,
                  BlendMode.srcIn,
                ),
              ),
              Flexible(
                child: Text(
                  ArStrings.homeSubjectUnit(
                    lesson.subject.title,
                    lesson.unit.title,
                  ),
                  style: AppTextStyles.label14.copyWith(
                    color: AppColors.onTeal,
                  ),
                ),
              ),
            ],
          ),
          Text(
            firstDay
                ? ArStrings.homeStartFirstLesson(lesson.lesson.title)
                : ArStrings.homeLessonTitle(
                    lesson.lesson.order,
                    lesson.lesson.title,
                  ),
            style: AppTextStyles.cardTitle20,
          ),
          if (firstDay)
            Text(
              ArStrings.homeLessonMeta(lesson.lesson.estimatedMinutes),
              style: AppTextStyles.caption13.copyWith(color: AppColors.onTeal),
            )
          else
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ProgressBar(
                    value: lesson.progress,
                    trackColor: AppColors.tealDark,
                    fillColor: AppColors.amber,
                    height: 10,
                  ),
                ),
                Text(
                  '$percent%',
                  style: AppTextStyles.body15.copyWith(color: AppColors.card),
                ),
              ],
            ),
          PrimaryButton(
            label: firstDay
                ? ArStrings.homeStartLesson
                : ArStrings.homeContinue,
            iconAsset: AppAssets.play,
            height: 48,
            backgroundColor: AppColors.card,
            foregroundColor: AppColors.teal,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
