/// رمز الصف الاختياري الذي يعطيه المعلم، مثل `GZ-5A`.
/// يُخزَّن محليًا فقط الآن؛ الانضمام الفعلي لمجموعة يأتي مع المزامنة.
abstract final class ClassCode {
  static const maxLength = 16;

  /// أحرف كبيرة بلا مسافات.
  static String normalize(String input) {
    return input.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  /// حروف إنجليزية وأرقام وشرطة فقط، ويبدأ وينتهي بحرف أو رقم.
  static bool isValid(String normalized) {
    if (normalized.isEmpty || normalized.length > maxLength) return false;
    return RegExp(r'^[A-Z0-9]+(-[A-Z0-9]+)*$').hasMatch(normalized);
  }
}
