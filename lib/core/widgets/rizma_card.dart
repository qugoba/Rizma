import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// بطاقة بيضاء بحد رفيع وزوايا 20 (CARD في التصميم).
class RizmaCard extends StatelessWidget {
  const RizmaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
