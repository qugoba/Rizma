import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// مربع ملوّن بزوايا مدوّرة يحوي أيقونة في الوسط.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.asset,
    required this.color,
    this.size = 48,
    this.iconSize = 24,
  });

  final String asset;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(asset, width: iconSize, height: iconSize),
    );
  }
}
