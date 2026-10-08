import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/primary_button.dart';

/// الشاشة 01 — مرحبًا
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Hero(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 18,
                  children: [
                    const _ValuePoint(
                      asset: AppAssets.bookTile,
                      tileColor: AppColors.tealTint,
                      title: ArStrings.welcomeValue1Title,
                      subtitle: ArStrings.welcomeValue1Subtitle,
                    ),
                    const _ValuePoint(
                      asset: AppAssets.cloudOff,
                      tileColor: AppColors.blueTint,
                      title: ArStrings.welcomeValue2Title,
                      subtitle: ArStrings.welcomeValue2Subtitle,
                    ),
                    const _ValuePoint(
                      asset: AppAssets.target,
                      tileColor: AppColors.amberTint,
                      title: ArStrings.welcomeValue3Title,
                      subtitle: ArStrings.welcomeValue3Subtitle,
                    ),
                    const _PageDots(count: 3, current: 0),
                    PrimaryButton(
                      label: ArStrings.welcomeStart,
                      iconAsset: AppAssets.fwdOnboarding,
                      onPressed: () => context.push(AppRoutes.createStep1),
                    ),
                    TextButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(ArStrings.restoreNeedsInternet),
                            ),
                          ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.teal,
                        textStyle: AppTextStyles.body15,
                      ),
                      child: const Text(ArStrings.welcomeHaveProfile),
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

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              SvgPicture.asset(
                AppAssets.tatreezBand,
                width: double.infinity,
                height: 24,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 0),
                child: Column(
                  spacing: 14,
                  children: [
                    SvgPicture.asset(
                      AppAssets.mascot150,
                      width: 150,
                      height: 150,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        SvgPicture.asset(
                          AppAssets.logoOnDark,
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          ArStrings.appName,
                          style: AppTextStyles.wordmark40,
                        ),
                      ],
                    ),
                    Text(
                      ArStrings.welcomeTagline,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.tagline18,
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

class _ValuePoint extends StatelessWidget {
  const _ValuePoint({
    required this.asset,
    required this.tileColor,
    required this.title,
    required this.subtitle,
  });

  final String asset;
  final Color tileColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14,
      children: [
        IconTile(asset: asset, color: tileColor),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body16Strong),
              Text(subtitle, style: AppTextStyles.caption13),
            ],
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == current ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == current ? AppColors.teal : AppColors.disabled,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
