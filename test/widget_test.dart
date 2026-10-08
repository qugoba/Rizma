import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizma/app/rizma_app.dart';
import 'package:rizma/core/strings/ar.dart';

import 'helpers/load_fonts.dart';

void main() {
  setUpAll(loadCairoFont);

  testWidgets('Welcome → grade selection → home flow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ProviderScope(child: RizmaApp()));
    await tester.pumpAndSettle();

    expect(find.text(ArStrings.welcomeStart), findsOneWidget);
    await tester.tap(find.text(ArStrings.welcomeStart));
    await tester.pumpAndSettle();

    expect(find.text(ArStrings.gradeTitle), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'أنس');
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    final continueLabel = ArStrings.continueWithGrade(5);
    expect(find.text(continueLabel), findsOneWidget);
    await tester.tap(find.text(continueLabel));
    await tester.pumpAndSettle();

    expect(find.text(ArStrings.homeGreeting('أنس')), findsOneWidget);
    expect(find.text(ArStrings.gradeName(5)), findsOneWidget);
  });
}
