import 'package:flutter/material.dart';

import '../../../core/strings/ar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/profile_palette.dart';
import '../../../core/widgets/mascot.dart';
import '../home_state.dart';

/// التحية: الصف + «مرحبًا/أهلًا، {الاسم}» + جملة، وأفاتار الطالب.
/// [onAvatarLongPress] لأدوات التطوير (debug فقط).
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.state, this.onAvatarLongPress});

  final HomeState state;
  final VoidCallback? onAvatarLongPress;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile;
    final firstDay = state.isFirstDay;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 4),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ArStrings.gradeName(profile.grade),
                  style: AppTextStyles.label14,
                ),
                Text(
                  firstDay
                      ? ArStrings.homeFirstDayGreeting(profile.name)
                      : ArStrings.homeGreeting(profile.name),
                  style: AppTextStyles.title26,
                ),
                Text(
                  firstDay
                      ? ArStrings.homeFirstDaySubtitle
                      : ArStrings.homeAskToday,
                  style: AppTextStyles.body15.copyWith(color: AppColors.soft),
                ),
              ],
            ),
          ),
          GestureDetector(
            onLongPress: onAvatarLongPress,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: profile.color.avatarBackground,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Mascot(size: 40, color: profile.color),
            ),
          ),
        ],
      ),
    );
  }
}
