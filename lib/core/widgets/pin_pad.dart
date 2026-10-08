import 'package:flutter/material.dart';

import '../strings/ar.dart';
import '../theme/app_colors.dart';

/// نقاط الرمز السري: المملوء منها = أرقام أُدخلت.
class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.length,
    required this.filled,
    this.error = false,
  });

  final int length;
  final int filled;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: ArStrings.pinDotsSemantics(filled, length),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            for (var i = 0; i < length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < filled
                      ? (error ? AppColors.coral : AppColors.teal)
                      : Colors.transparent,
                  border: i < filled
                      ? null
                      : Border.all(
                          color: error ? AppColors.coral : AppColors.disabled,
                          width: 2,
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// لوحة أرقام الرمز السري. مبنية LTR عمدًا (1 2 3 / 4 5 6 / 7 8 9 / فراغ 0 حذف)
/// كما في التصميم، حتى في واجهة RTL.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final bool enabled;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          for (final row in _rows)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 18,
              children: [for (final key in row) _buildKey(key)],
            ),
        ],
      ),
    );
  }

  Widget _buildKey(String key) {
    if (key.isEmpty) return const SizedBox(width: 80, height: 64);
    if (key == 'del') {
      return _PinKey(
        semanticsLabel: ArStrings.pinDelete,
        onTap: enabled ? onDelete : null,
        filled: false,
        child: const Icon(
          Icons.backspace_outlined,
          size: 26,
          color: AppColors.ink,
        ),
      );
    }
    return _PinKey(
      semanticsLabel: key,
      onTap: enabled ? () => onDigit(key) : null,
      filled: true,
      child: Text(
        key,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({
    required this.semanticsLabel,
    required this.onTap,
    required this.filled,
    required this.child,
  });

  final String semanticsLabel;
  final VoidCallback? onTap;
  final bool filled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        color: filled ? AppColors.card : Colors.transparent,
        shape: StadiumBorder(
          side: filled
              ? const BorderSide(color: AppColors.line)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(width: 80, height: 64, child: Center(child: child)),
        ),
      ),
    );
  }
}
