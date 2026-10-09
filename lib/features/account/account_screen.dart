import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/tab_navigation.dart';
import '../../core/constants/app_assets.dart';
import '../../core/db/app_database.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/profile_palette.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/rizma_card.dart';
import '../profiles/active_profile_provider.dart';
import '../profiles/pin_setup_sheet.dart';
import '../profiles/profile_providers.dart';
import 'pin_manage_sheet.dart';

/// الشاشة 19 «حسابي» — مجموعة «الملف» فقط (رمز الطالب، تبديل الطالب، الرمز
/// السري). مجموعات الدراسة والتنزيل والعام تنتظر مراحلها.
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final stars = ref.watch(starsByProfileProvider).value ?? const {};

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
                      ),
                      _ProfileHeader(profile: p, stars: stars[p.id] ?? 0),
                      _ProfileGroup(
                        profile: p,
                        onStudentCode: () =>
                            context.push(AppRoutes.studentCode),
                        onSwitch: () => context.go(AppRoutes.profiles),
                        onPin: () => _onPinTap(context, ref, p),
                      ),
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

    return RizmaCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              ArStrings.accountProfileGroup,
              style: AppTextStyles.section18,
            ),
          ),
          _SettingRow(
            icon: Icons.vpn_key_outlined,
            iconColor: AppColors.teal,
            tint: AppColors.tealTint,
            label: ArStrings.accountStudentCode,
            value: profile.studentCode,
            valueColor: AppColors.teal,
            valueLtr: true,
            onTap: onStudentCode,
          ),
          _SettingRow(
            icon: Icons.group_outlined,
            iconColor: AppColors.blue,
            tint: AppColors.blueTint,
            label: ArStrings.accountSwitch,
            onTap: onSwitch,
          ),
          _SettingRow(
            icon: Icons.lock_outline,
            iconColor: AppColors.purple,
            tint: AppColors.purpleTint,
            label: ArStrings.accountPin,
            value: pinOn ? ArStrings.accountPinOn : ArStrings.accountPinOff,
            valueColor: pinOn ? AppColors.teal : AppColors.soft,
            onTap: onPin,
          ),
        ],
      ),
    );
  }
}

/// صف إعداد: أيقونة ملوّنة، عنوان، قيمة اختيارية، وسهم. خط سفلي رفيع بين الصفوف.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.tint,
    required this.label,
    required this.onTap,
    this.value,
    this.valueColor = AppColors.teal,
    this.valueLtr = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color tint;
  final String label;
  final String? value;
  final Color valueColor;
  final bool valueLtr;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: value == null ? label : '$label، $value',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            spacing: 12,
            children: [
              IconTile(
                iconData: icon,
                iconColor: iconColor,
                color: tint,
                size: 40,
                iconSize: 20,
                radius: 12,
              ),
              Expanded(child: Text(label, style: AppTextStyles.body15)),
              if (value != null)
                Text(
                  value!,
                  textDirection: valueLtr ? TextDirection.ltr : null,
                  style: AppTextStyles.label14.copyWith(color: valueColor),
                ),
              SvgPicture.asset(AppAssets.fwdRow, width: 18, height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
