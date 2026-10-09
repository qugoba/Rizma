import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/tab_navigation.dart';
import '../../core/db/app_database.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/profile_palette.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/rizma_card.dart';
import '../catalog/catalog_providers.dart';
import '../profiles/active_profile_provider.dart';
import '../profiles/pin_setup_sheet.dart';
import '../profiles/profile_providers.dart';
import 'account_providers.dart';
import 'pin_manage_sheet.dart';
import 'preferences_repository.dart';
import 'widgets/account_sheets.dart';
import 'widgets/delete_profile_sheet.dart';
import 'widgets/setting_widgets.dart';
import '../../core/widgets/fade_slide_in.dart';

/// الشاشة 19 «حسابي»: الملف، الدراسة، التنزيل والتخزين، عام.
/// «الوضع الليلي» معطّل («قريبًا») لأن الثيم الداكن لم يُبنَ بعد، ومفاتيح
/// التخزين والأصوات تُحفظ الآن وتُقرأ حين تُبنى ميزاتها.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  void _note(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onPinTap(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final repo = ref.read(profileRepositoryProvider);
    final enabled = profile.pinHash != null;

    if (!enabled) {
      final pin = await showPinSetupSheet(context);
      if (pin == null) return;
      await repo.setPin(profile.id, pin);
      if (context.mounted) _note(context, ArStrings.pinEnabledNote);
      return;
    }

    final action = await showPinManageSheet(context);
    if (action == null || !context.mounted) return;
    switch (action) {
      case PinManageAction.change:
        final pin = await showPinSetupSheet(context);
        if (pin == null) return;
        await repo.setPin(profile.id, pin);
        if (context.mounted) _note(context, ArStrings.pinChangedNote);
      case PinManageAction.disable:
        await repo.clearPin(profile.id);
        if (context.mounted) _note(context, ArStrings.pinDisabledNote);
    }
  }

  Future<void> _onGradeTap(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    // صف الكتالوج المتوفّر؛ إن اختلف عن المختار نخبر الطالب.
    final contentGrade = ref.read(catalogProvider).value?.grade;
    final grade = await showGradeSheet(
      context,
      current: profile.grade,
      contentGrade: contentGrade,
    );
    if (grade == null || grade == profile.grade) return;
    await ref.read(profileRepositoryProvider).setGrade(profile.id, grade);
    if (context.mounted) _note(context, ArStrings.gradeChanged(grade));
  }

  Future<void> _onFontTap(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
    ProfilePrefs prefs,
  ) async {
    final choice = await showChoiceSheet<FontSizeChoice>(
      context,
      title: ArStrings.fontSheetTitle,
      options: [for (final c in FontSizeChoice.values) (c, _fontSizeLabel(c))],
      selected: prefs.fontSize,
    );
    if (choice == null) return;
    await ref
        .read(preferencesRepositoryProvider)
        .setFontSize(profile.id, choice);
  }

  Future<void> _onDeleteTap(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final confirmed = await showDeleteProfileSheet(context, profile);
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(profileRepositoryProvider).delete(profile.id);
    } catch (_) {
      if (context.mounted) _note(context, ArStrings.deleteFailed);
      return;
    }
    await ref.read(activeProfileIdProvider.notifier).reload();
    // شاشة الإقلاع تقرر الوجهة: اختيار ملف إن بقي أكثر من ملف، أو الترحيب إن لم يبقَ أحد.
    if (context.mounted) context.go(AppRoutes.launch);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final stars = ref.watch(starsByProfileProvider).value ?? const {};
    final prefs = ref.watch(activePrefsProvider).value ?? const ProfilePrefs();
    final prefsRepo = ref.read(preferencesRepositoryProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: profile.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => Center(
            child: Text(
              ArStrings.accountLoadFailed,
              style: AppTextStyles.body15,
            ),
          ),
          data: (p) => p == null
              ? const SizedBox.shrink()
              : SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 14,
                    children: [
                      Text(
                        ArStrings.accountTitle,
                        style: AppTextStyles.heading22,
                      ).fadeIn(0),
                      _ProfileHeader(
                        profile: p,
                        stars: stars[p.id] ?? 0,
                      ).fadeIn(1),
                      _ProfileGroup(
                        profile: p,
                        onStudentCode: () =>
                            context.push(AppRoutes.studentCode),
                        onSwitch: () => context.go(AppRoutes.profiles),
                        onPin: () => _onPinTap(context, ref, p),
                      ).fadeIn(2),
                      _StudyGroup(
                        profile: p,
                        prefs: prefs,
                        onGrade: () => _onGradeTap(context, ref, p),
                        onFontSize: () => _onFontTap(context, ref, p, prefs),
                        onGameSounds: (v) => prefsRepo.setGameSounds(p.id, v),
                      ).fadeIn(3),
                      _StorageGroup(
                        prefs: prefs,
                        onWifiOnly: (v) => prefsRepo.setWifiOnly(p.id, v),
                        onAutoVideo: (v) => prefsRepo.setAutoVideo(p.id, v),
                        onManage: () => context.push(AppRoutes.downloads),
                      ).fadeIn(4),
                      _GeneralGroup(
                        onPrivacy: () => showInfoSheet(
                          context,
                          title: ArStrings.privacyTitle,
                          paragraphs: const [
                            ArStrings.privacy1,
                            ArStrings.privacy2,
                            ArStrings.privacy3,
                          ],
                        ),
                        onAbout: () => showInfoSheet(
                          context,
                          title: ArStrings.aboutTitle,
                          paragraphs: const [
                            ArStrings.about1,
                            ArStrings.about2,
                            ArStrings.about3,
                          ],
                        ),
                      ).fadeIn(5),
                      _DeleteCard(
                        onTap: () => _onDeleteTap(context, ref, p),
                      ).fadeIn(6),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        current: RizmaTab.profile,
        onSelected: (tab) => onTabSelected(context, RizmaTab.profile, tab),
      ),
    );
  }
}

String _fontSizeLabel(FontSizeChoice choice) => switch (choice) {
  FontSizeChoice.small => ArStrings.fontSizeSmall,
  FontSizeChoice.medium => ArStrings.fontSizeMedium,
  FontSizeChoice.large => ArStrings.fontSizeLarge,
};

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile, required this.stars});

  final Profile profile;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return RizmaCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        spacing: 4,
        children: [
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: profile.color.avatarBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Mascot(size: 76, color: profile.color),
          ),
          Text(profile.name, style: AppTextStyles.title26),
          Text(
            ArStrings.accountSummary(profile.grade, stars),
            style: AppTextStyles.label14,
          ),
        ],
      ),
    );
  }
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({
    required this.profile,
    required this.onStudentCode,
    required this.onSwitch,
    required this.onPin,
  });

  final Profile profile;
  final VoidCallback onStudentCode;
  final VoidCallback onSwitch;
  final VoidCallback onPin;

  @override
  Widget build(BuildContext context) {
    final pinOn = profile.pinHash != null;

    return SettingsGroupCard(
      title: ArStrings.accountProfileGroup,
      children: [
        SettingRow(
          icon: Icons.vpn_key_outlined,
          iconColor: AppColors.teal,
          tint: AppColors.tealTint,
          label: ArStrings.accountStudentCode,
          value: profile.studentCode,
          valueColor: AppColors.teal,
          valueLtr: true,
          onTap: onStudentCode,
        ),
        SettingRow(
          icon: Icons.group_outlined,
          iconColor: AppColors.blue,
          tint: AppColors.blueTint,
          label: ArStrings.accountSwitch,
          onTap: onSwitch,
        ),
        SettingRow(
          icon: Icons.lock_outline,
          iconColor: AppColors.purple,
          tint: AppColors.purpleTint,
          label: ArStrings.accountPin,
          value: pinOn ? ArStrings.accountPinOn : ArStrings.accountPinOff,
          valueColor: pinOn ? AppColors.teal : AppColors.soft,
          onTap: onPin,
        ),
      ],
    );
  }
}

class _StudyGroup extends StatelessWidget {
  const _StudyGroup({
    required this.profile,
    required this.prefs,
    required this.onGrade,
    required this.onFontSize,
    required this.onGameSounds,
  });

  final Profile profile;
  final ProfilePrefs prefs;
  final VoidCallback onGrade;
  final VoidCallback onFontSize;
  final ValueChanged<bool> onGameSounds;

  @override
  Widget build(BuildContext context) {
    return SettingsGroupCard(
      title: ArStrings.accountStudyGroup,
      children: [
        SettingRow(
          icon: Icons.menu_book_outlined,
          iconColor: AppColors.teal,
          tint: AppColors.tealTint,
          label: ArStrings.accountGrade,
          value: ArStrings.gradeOrdinal(profile.grade),
          onTap: onGrade,
        ),
        SettingRow(
          icon: Icons.text_fields_rounded,
          iconColor: AppColors.blue,
          tint: AppColors.blueTint,
          label: ArStrings.accountFontSize,
          value: _fontSizeLabel(prefs.fontSize),
          onTap: onFontSize,
        ),
        SettingSwitchRow(
          icon: Icons.volume_up_outlined,
          iconColor: AppColors.purple,
          tint: AppColors.purpleTint,
          label: ArStrings.accountGameSounds,
          value: prefs.gameSounds,
          onChanged: onGameSounds,
        ),
      ],
    );
  }
}

class _StorageGroup extends StatelessWidget {
  const _StorageGroup({
    required this.prefs,
    required this.onWifiOnly,
    required this.onAutoVideo,
    required this.onManage,
  });

  final ProfilePrefs prefs;
  final ValueChanged<bool> onWifiOnly;
  final ValueChanged<bool> onAutoVideo;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return SettingsGroupCard(
      title: ArStrings.accountStorageGroup,
      footnote: ArStrings.accountStorageNote,
      children: [
        SettingSwitchRow(
          icon: Icons.wifi_rounded,
          iconColor: AppColors.teal,
          tint: AppColors.tealTint,
          label: ArStrings.accountWifiOnly,
          value: prefs.wifiOnly,
          onChanged: onWifiOnly,
        ),
        SettingSwitchRow(
          icon: Icons.videocam_outlined,
          iconColor: AppColors.coral,
          tint: AppColors.coralTint,
          label: ArStrings.accountAutoVideo,
          value: prefs.autoVideo,
          onChanged: onAutoVideo,
        ),
        SettingRow(
          icon: Icons.download_outlined,
          iconColor: AppColors.blue,
          tint: AppColors.blueTint,
          label: ArStrings.accountManageDownloads,
          onTap: onManage,
        ),
      ],
    );
  }
}

class _DeleteCard extends StatelessWidget {
  const _DeleteCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RizmaCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
      child: SettingRow(
        icon: Icons.delete_outline_rounded,
        iconColor: AppColors.coral,
        tint: AppColors.coralTint,
        label: ArStrings.accountDelete,
        labelColor: AppColors.coral,
        onTap: onTap,
      ),
    );
  }
}

class _GeneralGroup extends StatelessWidget {
  const _GeneralGroup({required this.onPrivacy, required this.onAbout});

  final VoidCallback onPrivacy;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return SettingsGroupCard(
      title: ArStrings.accountGeneralGroup,
      children: [
        const SoonSettingRow(
          icon: Icons.nights_stay_outlined,
          iconColor: AppColors.soft,
          tint: AppColors.mute,
          label: ArStrings.accountNightMode,
        ),
        SettingRow(
          icon: Icons.shield_outlined,
          iconColor: AppColors.teal,
          tint: AppColors.tealTint,
          label: ArStrings.accountPrivacy,
          onTap: onPrivacy,
        ),
        SettingRow(
          icon: Icons.public_rounded,
          iconColor: AppColors.amberDark,
          tint: AppColors.amberTint,
          label: ArStrings.accountAbout,
          onTap: onAbout,
        ),
      ],
    );
  }
}
