import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// مربع ملوّن بزوايا مدوّرة يحوي أيقونة في الوسط.
/// الأيقونة إما ملف SVG من Figma ([asset])، أو أيقونة Material ([iconData])
/// للأيقونات التي لم تُصدَّر من Figma بعد.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    this.asset,
    this.iconData,
    this.iconColor,
    required this.color,
    this.size = 48,
    this.iconSize = 24,
    this.radius = 14,
  }) : assert(
         (asset != null) != (iconData != null),
         'مرّر asset أو iconData (واحدًا فقط)',
       );

  final String? asset;
  final IconData? iconData;
  final Color? iconColor;
  final Color color;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: asset != null
          ? SvgPicture.asset(asset!, width: iconSize, height: iconSize)
          : Icon(iconData, size: iconSize, color: iconColor),
    );
  }
}
