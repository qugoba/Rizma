import 'dart:math';

/// رمز الطالب بصيغة `RZ-XXXX`. الأحرف بلا 0/O/1/I/L لتجنّب الالتباس.
/// التحقق من التفرّد على مستوى كل الأجهزة يأتي مع المزامنة لاحقًا.
abstract final class StudentCode {
  static const prefix = 'RZ-';

  /// طول الجزء العشوائي. غيّره من هنا فقط.
  static const randomLength = 4;

  static const alphabet = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';

  static String generate([Random? random]) {
    final rng = random ?? Random.secure();
    final body = List.generate(
      randomLength,
      (_) => alphabet[rng.nextInt(alphabet.length)],
    ).join();
    return '$prefix$body';
  }

  /// يوحّد الإدخال: أحرف كبيرة بلا مسافات.
  static String normalize(String input) {
    return input.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  static bool isValid(String code) {
    final pattern = RegExp(
      '^${RegExp.escape(prefix)}[$alphabet]{$randomLength}\$',
    );
    return pattern.hasMatch(code);
  }

  /// يولّد رمزًا غير مستخدم محليًا حسب [exists]. يرمي خطأ إن تعذّر ذلك
  /// بعد [maxTries] محاولة (احتمال ضئيل جدًا).
  static Future<String> generateUnique(
    Future<bool> Function(String code) exists, {
    Random? random,
    int maxTries = 50,
  }) async {
    for (var i = 0; i < maxTries; i++) {
      final code = generate(random);
      if (!await exists(code)) return code;
    }
    throw StateError('تعذّر توليد رمز طالب غير مكرر');
  }
}
