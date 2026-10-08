import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../strings/ar.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// زر الرجوع المربّع. أيقونته مرسومة بسهم لليمين = اتجاه الرجوع في RTL.
class BackTile extends StatelessWidget {
  const BackTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: ArStrings.back,
      excludeSemantics: true,
      child: Material(
        color: AppColors.mute,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: SvgPicture.asset(AppAssets.back, width: 22, height: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// الشريط العلوي: رجوع (يمين) ثم العنوان، وعنصر اختياري في الطرف الآخر.
class ScreenTopBar extends StatelessWidget {
  const ScreenTopBar({
    super.key,
    required this.title,
    this.subtitle,
    required this.onBack,
    this.end,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onBack;
  final Widget? end;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 4),
      child: Row(
        spacing: 12,
        children: [
          BackTile(onTap: onBack),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null)
                  Text(subtitle!, style: AppTextStyles.caption13),
                Text(title, style: AppTextStyles.heading22),
              ],
            ),
          ),
          ?end,
        ],
      ),
    );
  }
}
