import 'package:flutter/services.dart';

/// اهتزازات خفيفة تؤكد اللمس. مكان واحد فيسهل تعطيلها أو تعديلها لاحقًا.
abstract final class Haptics {
  /// نقرة خفيفة: مفاتيح، أرقام، تبويبات، اختيارات.
  static void tap() => HapticFeedback.selectionClick();

  /// اهتزاز أقوى لإجراء لا رجوع عنه (حذف).
  static void heavy() => HapticFeedback.mediumImpact();
}
