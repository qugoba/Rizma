import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum RizmaTab { home, subjects, progress, profile }

/// الشريط السفلي: الرئيسية · المواد · تقدّمي · حسابي (من اليمين لليسار).
class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.current, required this.onSelected});

  final RizmaTab current;
  final ValueChanged<RizmaTab> onSelected;

  static const _items = [
    (tab: RizmaTab.home, label: 'الرئيسية', asset: AppAssets.navHome),
    (tab: RizmaTab.subjects, label: 'المواد', asset: AppAssets.navBook),
    (tab: RizmaTab.progress, label: 'تقدّمي', asset: AppAssets.navChart),
    (tab: RizmaTab.profile, label: 'حسابي', asset: AppAssets.navUser),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final item in _items)
                _NavItem(
                  label: item.label,
                  asset: item.asset,
                  selected: item.tab == current,
                  onTap: () => onSelected(item.tab),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.teal : AppColors.soft;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? AppColors.tealTint : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                SvgPicture.asset(
                  asset,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                Text(
                  label,
                  style: AppTextStyles.captionBold13.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
