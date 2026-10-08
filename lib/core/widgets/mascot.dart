import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_assets.dart';
import '../db/enums.dart';
import '../theme/profile_palette.dart';

/// شخصية رِزمة بلون الطالب. الأصل أخضر، فنستبدل لونيه (الجسم والزاوية)
/// وقت العرض بدل الاحتفاظ بخمسة ملفات.
class Mascot extends StatelessWidget {
  const Mascot({super.key, required this.size, this.color = ProfileColor.teal});

  final double size;
  final ProfileColor color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.mascot150,
      width: size,
      height: size,
      colorMapper: _MascotColorMapper(body: color.body, fold: color.fold),
    );
  }
}

class _MascotColorMapper extends ColorMapper {
  const _MascotColorMapper({required this.body, required this.fold});

  static const _originalBody = Color(0xFF177A63);
  static const _originalFold = Color(0xFF7ED3B2);

  final Color body;
  final Color fold;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    if (color == _originalBody) return body;
    if (color == _originalFold) return fold;
    return color;
  }

  @override
  bool operator ==(Object other) =>
      other is _MascotColorMapper && other.body == body && other.fold == fold;

  @override
  int get hashCode => Object.hash(body, fold);
}
