import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/models/student_profile.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bottom_nav.dart';

/// الشاشة 03 — الرئيسية (مؤقتًا: التحية فقط حتى تُبنى الحالة من البيانات).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: _Greeting(profile: profile),
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

  final StudentProfile profile;

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
                Text(profile.gradeLabel, style: AppTextStyles.label14),
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
            decoration: const BoxDecoration(
              color: AppColors.tealTint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(AppAssets.mascot40, width: 40, height: 40),
          ),
        ],
      ),
    );
  }
}
