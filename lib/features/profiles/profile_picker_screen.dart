import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/db/app_database.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/profile_palette.dart';
import '../../core/widgets/dashed_border.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/mascot.dart';
import 'active_profile_provider.dart';
import 'profile_providers.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/fade_slide_in.dart';

/// الشاشة 25 — من يتعلّم الآن؟ (اختيار الملف).
class ProfilePickerScreen extends ConsumerWidget {
  const ProfilePickerScreen({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref, Profile p) async {
    if (p.pinHash != null) {
      context.push(AppRoutes.pin(p.id));
      return;
    }
    await ref.read(activeProfileIdProvider.notifier).select(p.id);
    if (context.mounted) context.go(AppRoutes.home);
  }

  void _showRestoreMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(ArStrings.restoreNeedsInternet)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // لا نعرض الشبكة قبل وصول الملفات، وإلا ظهرت بطاقة «طالب جديد» وحدها لحظة ثم قفزت البطاقات.
    final profiles = ref.watch(profilesProvider).value;
    final stars = ref.watch(starsByProfileProvider).value ?? const {};

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    const _Brand(),
                    const _Heading(),
                    if (profiles != null)
                      _ProfilesGrid(
                        profiles: profiles,
                        stars: stars,
                        onOpen: (p) => _open(context, ref, p),
                        onNew: () => context.push(AppRoutes.createStep1),
                      ),
                    const Spacer(),
                    _RestoreLink(onTap: () => _showRestoreMessage(context)),
                    const _PrivacyNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        SvgPicture.asset(AppAssets.logoOnDark, width: 34, height: 34),
        Text(
          ArStrings.appName,
          style: AppTextStyles.heading22.copyWith(height: 1.3),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(ArStrings.pickerTitle, style: AppTextStyles.title26),
        Text(
          ArStrings.pickerSubtitle,
          style: AppTextStyles.body15.copyWith(color: AppColors.soft),
        ),
      ],
    );
  }
}

class _ProfilesGrid extends StatelessWidget {
  const _ProfilesGrid({
    required this.profiles,
    required this.stars,
    required this.onOpen,
    required this.onNew,
  });

  final List<Profile> profiles;
  final Map<String, int> stars;
  final ValueChanged<Profile> onOpen;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    // صفوف من بطاقتين بدل Wrap + LayoutBuilder: الأخير لا يدعم قياس الأبعاد
    // الداخلية الذي تحتاجه SliverFillRemaining. الأولى تظهر على اليمين (RTL).
    final cards = <Widget>[
      for (final p in profiles)
        _ProfileCard(
          profile: p,
          stars: stars[p.id] ?? 0,
          onTap: () => onOpen(p),
        ),
      _NewProfileCard(onTap: onNew),
    ];

    return Column(
      spacing: 12,
      children: [
        for (var i = 0; i < cards.length; i += 2)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Expanded(child: cards[i].fadeIn(i)),
                Expanded(
                  child: i + 1 < cards.length
                      ? cards[i + 1].fadeIn(i + 1)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

const _cardMinHeight = 206.0;

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.stars,
    required this.onTap,
  });

  final Profile profile;
  final int stars;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locked = profile.pinHash != null;
    final grade = ArStrings.gradeName(profile.grade);

    return Semantics(
      button: true,
      label: ArStrings.profileSemantics(profile.name, grade, locked),
      excludeSemantics: true,
      child: Material(
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _cardMinHeight),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 16, 10, 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: profile.color.avatarBackground,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Mascot(size: 60, color: profile.color),
                  ),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.section18,
                  ),
                  Text(
                    grade,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption13,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    // FittedBox: البطاقة ضيقة على الشاشات الصغيرة (عمودان فقط).
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 6,
                        children: [
                          _StarsChip(stars: stars),
                          if (locked)
                            const IconTile(
                              iconData: Icons.lock_outline_rounded,
                              iconColor: AppColors.soft,
                              color: AppColors.mute,
                              size: 28,
                              iconSize: 16,
                              radius: 14,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).pressable();
  }
}

class _StarsChip extends StatelessWidget {
  const _StarsChip({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.amberTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          SvgPicture.asset(AppAssets.starFilled, width: 16, height: 16),
          Text(
            ArStrings.stars(stars),
            style: AppTextStyles.chip13.copyWith(color: AppColors.amberDark),
          ),
        ],
      ),
    );
  }
}

class _NewProfileCard extends StatelessWidget {
  const _NewProfileCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: ArStrings.pickerNewTitle,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _cardMinHeight),
          child: DashedBorderBox(
            color: AppColors.disabled,
            radius: 22,
            dash: 8,
            gap: 6,
            padding: const EdgeInsetsDirectional.fromSTEB(10, 16, 10, 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                const IconTile(
                  iconData: Icons.add_rounded,
                  iconColor: AppColors.teal,
                  color: AppColors.tealTint,
                  size: 64,
                  iconSize: 30,
                  radius: 32,
                ),
                Text(
                  ArStrings.pickerNewTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.section18.copyWith(
                    color: AppColors.teal,
                  ),
                ),
                Text(
                  ArStrings.pickerNewSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption13,
                ),
              ],
            ),
          ),
        ),
      ),
    ).pressable();
  }
}

class _RestoreLink extends StatelessWidget {
  const _RestoreLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: ArStrings.pickerRestoreTitle,
      excludeSemantics: true,
      child: Material(
        color: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
            child: Row(
              spacing: 12,
              children: [
                const IconTile(
                  iconData: Icons.sync_rounded,
                  iconColor: AppColors.blue,
                  color: AppColors.blueTint,
                  size: 44,
                  iconSize: 22,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ArStrings.pickerRestoreTitle,
                        style: AppTextStyles.body16Strong,
                      ),
                      Text(
                        ArStrings.pickerRestoreSubtitle,
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
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        const Icon(Icons.shield_outlined, size: 16, color: AppColors.soft),
        Flexible(
          child: Text(
            ArStrings.pickerPrivacy,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption13,
          ),
        ),
      ],
    );
  }
}
