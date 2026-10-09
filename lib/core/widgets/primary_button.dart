import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'pressable_scale.dart';

/// الزر الرئيسي العريض. إذا كان [onPressed] فارغًا يظهر معطّلًا.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconAsset,
    this.height = 52,
    this.backgroundColor = AppColors.teal,
    this.foregroundColor = AppColors.card,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? iconAsset;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: enabled ? backgroundColor : AppColors.disabled,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                if (iconAsset != null)
                  SvgPicture.asset(iconAsset!, width: 20, height: 20),
                Text(
                  label,
                  style: AppTextStyles.button16.copyWith(
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).pressable(enabled: enabled);
  }
}
