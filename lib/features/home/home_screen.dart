import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/tab_navigation.dart';
import '../../core/db/database_provider.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bottom_nav.dart';
import '../catalog/catalog_providers.dart';
import 'dev_tools_sheet.dart';
import 'home_providers.dart';
import 'home_state.dart';
import 'widgets/featured_lesson_card.dart';
import 'widgets/first_steps_card.dart';
import 'widgets/home_greeting.dart';
import 'widgets/review_section.dart';
import 'widgets/reward_chips.dart';
import 'widgets/subjects_section.dart';

/// الشاشتان 03 (الرئيسية) و28 (الرئيسية — أول يوم): شاشة واحدة تتبدّل
/// بحسب [HomeState] المشتق من البيانات.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(ArStrings.homeLessonSoon)));
  }

  Future<void> _openDevTools(BuildContext context, WidgetRef ref, HomeState s) {
    return showDevToolsSheet(
      context,
      db: ref.read(appDatabaseProvider),
      profile: s.profile,
      catalog: ref.read(catalogProvider).requireValue,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeStateProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: state.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => Center(
            child: Text(ArStrings.homeLoadFailed, style: AppTextStyles.body15),
          ),
          data: (s) => s == null
              ? const SizedBox.shrink()
              : _HomeBody(
                  state: s,
                  onSoon: () => _soon(context),
                  onAvatarLongPress: kDebugMode
                      ? () => _openDevTools(context, ref, s)
                      : null,
                ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        current: RizmaTab.home,
        onSelected: (tab) => onTabSelected(context, RizmaTab.home, tab),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.state,
    required this.onSoon,
    required this.onAvatarLongPress,
  });

  final HomeState state;
  final VoidCallback onSoon;
  final VoidCallback? onAvatarLongPress;

  @override
  Widget build(BuildContext context) {
    final featured = state.featured;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          HomeGreeting(state: state, onAvatarLongPress: onAvatarLongPress),
          if (state.hasActivity)
            RewardChips(stars: state.stars, streak: state.streak),
          if (featured != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: FeaturedLessonCard(
                lesson: featured,
                firstDay: state.isFirstDay,
                onPressed: onSoon,
              ),
            ),
          if (state.isFirstDay)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: FirstStepsCard(steps: state.firstSteps),
            ),
          if (state.showReviewPlaceholder)
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: ReviewPlaceholder(),
            ),
          if (state.showReviewSection)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: ReviewSection(
                items: state.review,
                onReview: (_) => onSoon(),
              ),
            ),
          SubjectsHeader(onShowAll: onSoon),
          SubjectsCarousel(subjects: state.subjects, onOpen: (_) => onSoon()),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
