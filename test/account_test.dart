import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizma/core/db/app_database.dart';
import 'package:rizma/core/strings/ar.dart';
import 'package:rizma/features/account/account_providers.dart';
import 'package:rizma/features/profiles/profile_repository.dart';

import 'helpers/app_harness.dart';
import 'helpers/load_fonts.dart';

/// المرحلة 6: «حسابي» (19) و«رمز الطالب» (29).
void main() {
  setUpAll(loadCairoFont);

  Future<void> seedAnas(ProfileRepository repo) async {
    await repo.create(name: 'أنس', grade: 5, color: ProfileColor.teal);
  }

  Future<void> openAccount(WidgetTester tester) async {
    await tester.tap(find.text(ArStrings.navProfile));
    await tester.pumpAndSettle();
  }

  Future<Profile> only(WidgetTester tester, AppDatabase db) async {
    final all = await onDb(tester, db.profilesDao.getAll);
    return all.single;
  }

  group('حسابي', () {
    testWidgets(
      'يعرض الاسم والصف والنجوم الحقيقية ورمز الطالب والرمز السري غير مفعّل',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        final p = await only(tester, db);
        await onDb(
          tester,
          () => db.activityDao.insertAttempt(
            profileId: p.id,
            activityId: 'x',
            kind: AttemptKind.practice,
            score: 3,
            total: 4,
            starsEarned: 3,
            now: DateTime(2026, 1, 1),
          ),
        );
        await openAccount(tester);

        expect(find.text('أنس'), findsOneWidget);
        expect(find.text(ArStrings.accountSummary(5, 3)), findsOneWidget);
        expect(find.text(p.studentCode), findsOneWidget);
        expect(find.text(ArStrings.accountPinOff), findsOneWidget);
        expect(find.text(ArStrings.accountProfileGroup), findsOneWidget);
      }),
    );

    testWidgets(
      'تبويب الرئيسية يعود إلى الرئيسية، وتبويب غير مبني يعرض رسالة',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        await openAccount(tester);
        await tester.tap(find.text(ArStrings.navSubjects));
        await tester.pump();
        expect(find.text(ArStrings.navSectionSoon), findsOneWidget);

        await tester.tap(find.text(ArStrings.navHome));
        await tester.pumpAndSettle();
        expect(
          find.text(ArStrings.homeFirstDayGreeting('أنس')),
          findsOneWidget,
        );
      }),
    );

    testWidgets(
      '«تبديل الطالب» يفتح شاشة اختيار الملف',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        await openAccount(tester);
        await tester.tap(find.text(ArStrings.accountSwitch));
        await tester.pumpAndSettle();
        expect(find.text(ArStrings.pickerTitle), findsOneWidget);
      }),
    );

    testWidgets(
      'تفعيل الرمز السري ثم تغييره ثم إلغاؤه',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        await openAccount(tester);

        // تفعيل
        await tester.tap(find.text(ArStrings.accountPin));
        await tester.pumpAndSettle();
        await enterPin(tester, '1234');
        await enterPin(tester, '1234');
        expect(find.text(ArStrings.accountPinOn), findsOneWidget);
        final before = (await only(tester, db)).pinHash;
        expect(before, isNotNull);

        // تغيير: يبقى مفعّلًا والتجزئة تتغيّر
        await tester.tap(find.text(ArStrings.accountPin));
        await tester.pumpAndSettle();
        await tester.tap(find.text(ArStrings.pinChange));
        await tester.pumpAndSettle();
        await enterPin(tester, '5678');
        await enterPin(tester, '5678');
        final after = (await only(tester, db)).pinHash;
        expect(after, isNotNull);
        expect(after, isNot(before));

        // إلغاء
        await tester.tap(find.text(ArStrings.accountPin));
        await tester.pumpAndSettle();
        await tester.tap(find.text(ArStrings.pinDisable));
        await tester.pumpAndSettle();
        expect(find.text(ArStrings.accountPinOff), findsOneWidget);
        expect((await only(tester, db)).pinHash, isNull);
      }),
    );

    testWidgets(
      'إغلاق ورقة الرمز السري دون إكماله لا يغيّر شيئًا',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        await openAccount(tester);
        await tester.tap(find.text(ArStrings.accountPin));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(20, 60)); // خارج الورقة
        await tester.pumpAndSettle();
        expect(find.text(ArStrings.accountPinOff), findsOneWidget);
        expect((await only(tester, db)).pinHash, isNull);
      }),
    );
  });

  group('رمز الطالب', () {
    Future<void> openCode(WidgetTester tester) async {
      await openAccount(tester);
      await tester.tap(find.text(ArStrings.accountStudentCode));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'يعرض الرمز وأسباب وجوده وحالة «لم يُحفظ» وبلا مجموعة صف',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        final p = await only(tester, db);
        await openCode(tester);

        expect(find.text(p.studentCode), findsOneWidget);
        expect(find.text(ArStrings.codeWhyTitle), findsOneWidget);
        expect(find.text(ArStrings.codeNeverSynced), findsOneWidget);
        expect(find.text(ArStrings.codeNothingPending), findsOneWidget);
        expect(find.text(ArStrings.codeClassGroup), findsNothing);
      }),
    );

    testWidgets(
      'عدد النتائج المنتظرة يأتي من طابور المزامنة ويتحدّث',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        await openCode(tester);
        for (var i = 0; i < 3; i++) {
          await onDb(
            tester,
            () => db.activityDao.enqueueSync(
              entity: 'attempt',
              payloadJson: '{}',
              now: DateTime(2026, 1, 1),
            ),
          );
        }
        expect(find.text(ArStrings.codePending(3)), findsOneWidget);
      }),
    );

    testWidgets(
      'مجموعة الصف تظهر عند وجود رمز صف',
      (tester) => scenario(
        tester,
        seed: (repo) async {
          await repo.create(
            name: 'أنس',
            grade: 5,
            color: ProfileColor.teal,
            classCode: 'gz-5a',
          );
        },
        (db) async {
          await openCode(tester);
          expect(find.text(ArStrings.codeClassGroup), findsOneWidget);
          expect(find.text(ArStrings.codeClassLine('GZ-5A')), findsOneWidget);
        },
      ),
    );

    testWidgets(
      'النسخ يضع الرمز في الحافظة ويعرض تأكيدًا',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        final p = await only(tester, db);
        String? clipboard;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              clipboard = (call.arguments as Map)['text'] as String?;
            }
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );

        await openCode(tester);
        await tester.tap(find.text(ArStrings.codeCopy));
        await tester.pump();
        await tester.pump();

        expect(clipboard, p.studentCode);
        expect(find.text(ArStrings.codeCopied), findsOneWidget);
      }),
    );

    testWidgets('المشاركة ترسل رسالة فيها الرمز', (tester) {
      final shared = <String>[];
      return scenario(
        tester,
        overrides: [
          shareTextProvider.overrideWithValue((text) async {
            shared.add(text);
          }),
        ],
        seed: seedAnas,
        (db) async {
          final p = await only(tester, db);
          await openCode(tester);
          await tester.tap(find.text(ArStrings.codeShare));
          await tester.pump();

          expect(shared, [ArStrings.codeShareMessage(p.studentCode)]);
        },
      );
    });

    testWidgets(
      'زر الرجوع يعيد إلى حسابي',
      (tester) => scenario(tester, seed: seedAnas, (db) async {
        await openCode(tester);
        await tester.tap(find.bySemanticsLabel(ArStrings.back));
        await tester.pumpAndSettle();
        expect(find.text(ArStrings.accountProfileGroup), findsOneWidget);
        expect(find.text(ArStrings.codeWhyTitle), findsNothing);
      }),
    );
  });
}
