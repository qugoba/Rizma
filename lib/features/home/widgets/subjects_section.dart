import 'package:flutter/material.dart';

import '../../../core/strings/ar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/profile_palette.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../catalog/subject_visuals.dart';
import '../home_state.dart';

/// رأس «موادي» + «عرض الكل».
class SubjectsHeader extends StatelessWidget {
  const SubjectsHeader({super.key, required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Text(
              ArStrings.homeMySubjects,
              style: AppTextStyles.section18,
            ),
          ),
          TextButton(
            onPressed: onShowAll,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.teal,
              textStyle: AppTextStyles.label14,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(ArStrings.homeShowAll),
          ),
        ],
      ),
    );
  }
}

/// شريط أفقي لبطاقات المواد، الأولى على اليمين (RTL).
class SubjectsCarousel extends StatelessWidget {
  const SubjectsCarousel({
    super.key,
    required this.subjects,
    required this.onOpen,
  });

  final List<SubjectProgress> subjects;
  final ValueChanged<SubjectProgress> onOpen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          for (final s in subjects)
            _SubjectCard(progress: s, onTap: () => onOpen(s)),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.progress, required this.onTap});

  final SubjectProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subject = progress.subject;
    final accent = subject.color.body;
    final percent = (progress.fraction * 100).round();

    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                IconTile(
                  asset: subjectIconAsset(subject.icon),
                  color: subject.color.avatarBackground,
                  size: 44,
                  iconSize: 22,
                ),
                Text(subject.title, style: AppTextStyles.body15),
                if (progress.started)
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: ProgressBar(
                          value: progress.fraction,
                          trackColor: AppColors.mute,
                          fillColor: accent,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: AppTextStyles.percent12.copyWith(color: accent),
                      ),
                    ],
                  )
                else
                  Text(
                    ArStrings.homeNotStarted,
                    style: AppTextStyles.percent12.copyWith(
                      color: AppColors.soft,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
