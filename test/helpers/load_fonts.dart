import 'package:flutter/services.dart';

/// يحمّل خط Cairo الحقيقي في الاختبارات. بدونه يستخدم `flutter_test` خطًّا
/// بديلًا عريضًا (Ahem) فتظهر أخطاء تجاوز عرض وهمية.
Future<void> loadCairoFont() async {
  final loader = FontLoader('Cairo');
  for (final weight in const ['Regular', 'SemiBold', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('assets/fonts/Cairo-$weight.ttf'));
  }
  await loader.load();
}
