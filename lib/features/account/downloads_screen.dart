import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/screen_top_bar.dart';

/// «إدارة التنزيلات». لا تنزيلات في التطبيق بعد، فنعرض حالة فارغة صادقة
/// بدل قائمة وأحجام وهمية.
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenTopBar(
              title: ArStrings.downloadsTitle,
              subtitle: ArStrings.accountTitle,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.account),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      const IconTile(
                        iconData: Icons.download_outlined,
                        iconColor: AppColors.blue,
                        color: AppColors.blueTint,
                        size: 72,
                        iconSize: 34,
                        radius: 24,
                      ),
                      Text(
                        ArStrings.downloadsEmptyTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.section18,
                      ),
                      Text(
                        ArStrings.downloadsEmptyBody,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
