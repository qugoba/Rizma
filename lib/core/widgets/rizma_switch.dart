import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// مفتاح التشغيل بحسب التصميم (52×32). المقبض يبدأ من اليمين وهو مطفأ (RTL).
class RizmaSwitch extends StatelessWidget {
  const RizmaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticsLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: semanticsLabel,
      excludeSemantics: true,
      onTap: () => onChanged(!value),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 52,
          height: 32,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: value ? AppColors.teal : AppColors.disabled,
            borderRadius: BorderRadius.circular(16),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            alignment: value
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: 24, height: 24),
            ),
          ),
        ),
      ),
    );
  }
}
