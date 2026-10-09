import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/db/app_database.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/rizma_card.dart';
import '../../core/widgets/screen_top_bar.dart';
import '../profiles/active_profile_provider.dart';
import 'account_providers.dart';

/// الشاشة 29 «رمز الطالب»: الرمز مع نسخ ومشاركة، وسبب وجوده، وحالة الحفظ على
/// الإنترنت. مجموعة الصف تظهر فقط إن أدخل الطالب رمز صف.
class StudentCodeScreen extends ConsumerWidget {
  const StudentCodeScreen({super.key});

  void _back(BuildContext context) {
    context.canPop() ? context.pop() : context.go(AppRoutes.account);
  }

  Future<void> _copy(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(ArStrings.codeCopied)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider).value;
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;

    return Scaffold(
      body: SafeArea(
        child: profile == null
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ScreenTopBar(
                      title: ArStrings.codeTitle,
                      subtitle: ArStrings.accountTitle,
                      onBack: () => _back(context),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        12,
                        20,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 14,
                        children: [
                          _CodeCard(
                            code: profile.studentCode,
                            onCopy: () => _copy(context, profile.studentCode),
                            onShare: () => ref.read(shareTextProvider)(
                              ArStrings.codeShareMessage(profile.studentCode),
                            ),
                          ),
                          const _WhyCard(),
                          _InfoRow(
                            iconData: Icons.sync_rounded,
                            iconColor: AppColors.teal,
                            tint: AppColors.tealTint,
                            title: ArStrings.codeNeverSynced,
                            caption: pending == 0
                                ? ArStrings.codeNothingPending
                                : ArStrings.codePending(pending),
                          ),
                          if (profile.classCode != null)
                            _ClassGroupRow(profile: profile),
                          const SizedBox(height: 4),
                          Text(
                            ArStrings.codeKeepSafe,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.code,
    required this.onCopy,
    required this.onShare,
  });

  final String code;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        spacing: 8,
        children: [
          Text(
            ArStrings.codeYours,
            style: AppTextStyles.label14.copyWith(
              color: const Color(0xFFB9CFC8),
            ),
          ),
          Text(
            code,
            textDirection: TextDirection.ltr,
            style: AppTextStyles.wordmark40.copyWith(letterSpacing: 1),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: _CodeButton(
                    icon: Icons.copy_rounded,
                    label: ArStrings.codeCopy,
                    onTap: onCopy,
                  ),
                ),
                Expanded(
                  child: _CodeButton(
                    icon: Icons.share_outlined,
                    label: ArStrings.codeShare,
                    onTap: onShare,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeButton extends StatelessWidget {
  const _CodeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: const Color(0xFF173A3E),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(icon, size: 18, color: const Color(0xFF7ED3B2)),
                Text(
                  label,
                  style: AppTextStyles.label14.copyWith(color: AppColors.light),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhyCard extends StatelessWidget {
  const _WhyCard();

  @override
  Widget build(BuildContext context) {
    return RizmaCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Text(ArStrings.codeWhyTitle, style: AppTextStyles.section18),
          const _WhyRow(
            icon: Icons.phone_android_rounded,
            iconColor: AppColors.teal,
            tint: AppColors.tealTint,
            text: ArStrings.codeWhy1,
          ),
          const _WhyRow(
            icon: Icons.group_outlined,
            iconColor: AppColors.blue,
            tint: AppColors.blueTint,
            text: ArStrings.codeWhy2,
          ),
          const _WhyRow(
            icon: Icons.shield_outlined,
            iconColor: AppColors.purple,
            tint: AppColors.purpleTint,
            text: ArStrings.codeWhy3,
          ),
        ],
      ),
    );
  }
}

class _WhyRow extends StatelessWidget {
  const _WhyRow({
    required this.icon,
    required this.iconColor,
    required this.tint,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final Color tint;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          Expanded(child: Text(text, style: AppTextStyles.body15)),
        ],
      ),
    );
  }
}

class _ClassGroupRow extends StatelessWidget {
  const _ClassGroupRow({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return _InfoRow(
      iconData: Icons.group_outlined,
      iconColor: AppColors.amberDark,
      tint: AppColors.amberTint,
      title: ArStrings.codeClassGroup,
      caption: ArStrings.codeClassLine(profile.classCode!),
    );
  }
}

/// بطاقة معلومة: أيقونة ملوّنة وسطر عنوان وسطر توضيح.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.iconData,
    required this.iconColor,
    required this.tint,
    required this.title,
    required this.caption,
  });

  final IconData iconData;
  final Color iconColor;
  final Color tint;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          spacing: 12,
          children: [
            IconTile(
              iconData: iconData,
              iconColor: iconColor,
              color: tint,
              size: 40,
              iconSize: 20,
              radius: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body15),
                  Text(caption, style: AppTextStyles.caption13),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
