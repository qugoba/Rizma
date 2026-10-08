import 'package:flutter/painting.dart';

import '../db/enums.dart';

/// ألوان شخصية الطالب الخمسة (من مواصفات التصميم).
/// `body` و`fold` يحلّان محل لوني الشخصية الأصلية (teal) عبر `ColorMapper`.
extension ProfileColorPalette on ProfileColor {
  /// لون جسم الشخصية.
  Color get body => switch (this) {
    ProfileColor.teal => const Color(0xFF177A63),
    ProfileColor.coral => const Color(0xFFB94F2A),
    ProfileColor.blue => const Color(0xFF2F66C9),
    ProfileColor.purple => const Color(0xFF6A4FB3),
    ProfileColor.amber => const Color(0xFFB07316),
  };

  /// لون الزاوية المطوية.
  Color get fold => switch (this) {
    ProfileColor.teal => const Color(0xFF7ED3B2),
    ProfileColor.coral => const Color(0xFFF3B9A3),
    ProfileColor.blue => const Color(0xFFA9C2F0),
    ProfileColor.purple => const Color(0xFFC9BCEB),
    ProfileColor.amber => const Color(0xFFF1D29C),
  };

  /// خلفية الأفاتار خلف الشخصية.
  Color get avatarBackground => switch (this) {
    ProfileColor.teal => const Color(0xFFDCEFE6),
    ProfileColor.coral => const Color(0xFFF8E1D7),
    ProfileColor.blue => const Color(0xFFDEE7F8),
    ProfileColor.purple => const Color(0xFFE9E3F6),
    ProfileColor.amber => const Color(0xFFFCEFD6),
  };
}
