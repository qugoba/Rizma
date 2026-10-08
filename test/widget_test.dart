import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizma/app/rizma_app.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Welcome → grade selection → home flow', (tester) async {
    // في الاختبارات لا يتوفر خط Cairo فيُستخدم خط بديل عريض (Ahem)،
    // فنتجاهل أخطاء تجاوز العرض الناتجة عنه فقط.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const RizmaApp());
    await tester.pumpAndSettle();

    expect(find.text('ابدأ'), findsOneWidget);
    await tester.tap(find.text('ابدأ'));
    await tester.pumpAndSettle();

    expect(find.text('اختر صفّك'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'أنس');
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(find.text('متابعة · الصف 5'), findsOneWidget);
    await tester.tap(find.text('متابعة · الصف 5'));
    await tester.pumpAndSettle();

    expect(find.text('مرحبًا، أنس'), findsOneWidget);
    expect(find.text('الصف الخامس'), findsOneWidget);
  });
}
