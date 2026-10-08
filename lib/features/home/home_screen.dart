import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/profile_palette.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/mascot.dart';
import '../profiles/active_profile_provider.dart';

/// الشاشة 03 — الرئيسية (مؤقتًا: التحية فقط حتى تُبنى الحالة من البيانات).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider).value;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: profile == null ? null : _Greeting(profile: profile),
        ),
      ),
      bottomNavigationBar: BottomNav(
        current: RizmaTab.home,
        onSelected: (_) {},
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
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
                  ArStrings.homeGreeting(profile.name),
                  style: AppTextStyles.title26,
                ),
                Text(
                  ArStrings.homeAskToday,
                  style: AppTextStyles.body15.copyWith(color: AppColors.soft),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: profile.color.avatarBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Mascot(size: 40, color: profile.color),
          ),
        ],
      ),
    );
  }
}
