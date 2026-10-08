import 'package:flutter/material.dart';

import '../../../core/strings/ar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/rizma_card.dart';
import '../home_state.dart';

/// «خطواتك الأولى X من 3»: كل خطوة تُحسب من البيانات.
class FirstStepsCard extends StatelessWidget {
  const FirstStepsCard({super.key, required this.steps});

  final FirstSteps steps;

  @override
  Widget build(BuildContext context) {
    return RizmaCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  ArStrings.homeFirstSteps,
                  style: AppTextStyles.section18,
                ),
              ),
              Text(
                ArStrings.homeFirstStepsCount(steps.done),
                style: AppTextStyles.label14,
              ),
            ],
          ),
          _StepRow(
            icon: Icons.file_download_outlined,
            title: ArStrings.homeStepDownload,
            hint: ArStrings.homeStepDownloadHint,
            done: steps.downloaded,
          ),
          _StepRow(
            icon: Icons.track_changes_rounded,
            title: ArStrings.homeStepPractice,
            hint: ArStrings.homeStepPracticeHint,
            done: steps.practiced,
          ),
          _StepRow(
            icon: Icons.emoji_events_outlined,
            title: ArStrings.homeStepQuiz,
            hint: ArStrings.homeStepQuizHint,
            done: steps.quizzed,
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.icon,
    required this.title,
    required this.hint,
    required this.done,
  });

  final IconData icon;
  final String title;
  final String hint;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title، $hint',
      checked: done,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          spacing: 12,
          children: [
            _Checkbox(done: done),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body15),
                  Text(hint, style: AppTextStyles.caption13),
                ],
              ),
            ),
            IconTile(
              iconData: icon,
              iconColor: AppColors.soft,
              color: AppColors.mute,
              size: 36,
              iconSize: 18,
              radius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? AppColors.teal : Colors.transparent,
        border: done ? null : Border.all(color: AppColors.disabled, width: 2),
      ),
      child: done
          ? const Icon(Icons.check_rounded, size: 16, color: AppColors.card)
          : null,
    );
  }
}
