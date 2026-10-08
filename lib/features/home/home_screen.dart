import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/models/student_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/progress_bar.dart';
import 'home_sample_data.dart';

/// الشاشة 03 — الرئيسية
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Greeting(profile: profile),
              const SizedBox(height: 12),
              const _RewardChips(),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _ContinueLearningCard(),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _NeedsReviewSection(),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _DailyChallengeRow(),
              ),
              const SizedBox(height: 16),
              const _MySubjectsHeader(),
              const SizedBox(height: 16),
              const _SubjectsCarousel(),
              const SizedBox(height: 24),
            ],
          ),
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.gradeLabel, style: AppTextStyles.label14),
                Text('مرحبًا، ${profile.name}', style: AppTextStyles.title26),
                Text(
                  'ماذا تريد أن تتعلم اليوم؟',
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

class _RewardChips extends StatelessWidget {
  const _RewardChips();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        spacing: 8,
        children: [
          _Chip(
            asset: AppAssets.flame,
            label: '${HomeSampleData.streakDays} أيام متتالية',
            background: AppColors.coralTint,
            foreground: AppColors.coral,
          ),
          _Chip(
            asset: AppAssets.starFilled,
            label: '${HomeSampleData.stars} نجمة',
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

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
              SvgPicture.asset(AppAssets.calcCard, width: 18, height: 18),
              Text(
                HomeSampleData.currentSubject,
                style: AppTextStyles.label14.copyWith(color: AppColors.onTeal),
              ),
            ],
          ),
          Text(HomeSampleData.currentLesson, style: AppTextStyles.cardTitle20),
          Row(
            spacing: 10,
            children: [
              const Expanded(
                child: ProgressBar(
                  value: HomeSampleData.currentProgress,
                  trackColor: AppColors.tealDark,
                  fillColor: AppColors.amber,
                  height: 10,
                ),
              ),
              Text(
                '${(HomeSampleData.currentProgress * 100).round()}%',
                style: AppTextStyles.body15.copyWith(color: AppColors.card),
              ),
            ],
          ),
          PrimaryButton(
            label: 'متابعة التعلم',
            iconAsset: AppAssets.play,
            height: 48,
            backgroundColor: AppColors.card,
            foregroundColor: AppColors.teal,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _NeedsReviewSection extends StatelessWidget {
  const _NeedsReviewSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Text('يحتاج إلى مراجعة', style: AppTextStyles.section18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    Text(
                      HomeSampleData.reviewTopic,
                      style: AppTextStyles.body16Strong,
                    ),
                    Text(
                      HomeSampleData.reviewDetails,
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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    child: Text(
                      'راجِع',
                      style: AppTextStyles.label14.copyWith(
                        color: AppColors.card,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyChallengeRow extends StatelessWidget {
  const _DailyChallengeRow();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            spacing: 14,
            children: [
              const IconTile(
                asset: AppAssets.bolt,
                color: AppColors.purpleTint,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تحدّي اليوم', style: AppTextStyles.body16Strong),
                    Text(
                      HomeSampleData.challengeSubtitle,
                      style: AppTextStyles.caption13,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(AppAssets.fwdRow, width: 20, height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MySubjectsHeader extends StatelessWidget {
  const _MySubjectsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        spacing: 8,
        children: [
          Expanded(child: Text('موادي', style: AppTextStyles.section18)),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.teal,
              textStyle: AppTextStyles.label14,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('عرض الكل'),
          ),
        ],
      ),
    );
  }
}

class _SubjectsCarousel extends StatelessWidget {
  const _SubjectsCarousel();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          for (final subject in HomeSampleData.subjects)
            _SubjectCard(subject: subject),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});

  final SubjectSummary subject;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                IconTile(
                  asset: subject.iconAsset,
                  color: subject.tileColor,
                  size: 44,
                  iconSize: 22,
                ),
                Text(subject.name, style: AppTextStyles.body15),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ProgressBar(
                        value: subject.progress,
                        trackColor: AppColors.mute,
                        fillColor: subject.accent,
                      ),
                    ),
                    Text(
                      subject.percentLabel,
                      style: AppTextStyles.percent12.copyWith(
                        color: subject.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
