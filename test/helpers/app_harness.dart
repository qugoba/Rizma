import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizma/app/rizma_app.dart';
import 'package:rizma/core/db/app_database.dart';
import 'package:rizma/core/db/database_provider.dart';
import 'package:rizma/features/catalog/catalog_providers.dart';
import 'package:rizma/features/catalog/catalog_repository.dart';
import 'package:rizma/features/profiles/profile_repository.dart';

/// نص الكتالوج يُقرأ مرة واحدة بشكل متزامن: قراءة ملف حقيقية داخل الزمن الوهمي
/// لا تكتمل أبدًا، وتخزين rootBundle المؤقت يورّث الفشل للاختبارات التالية.
final String _catalogJson = File(
  'assets/content/catalog_grade5.json',
).readAsStringSync();

/// يشغّل التطبيق على قاعدة في الذاكرة، ثم ينظّف خارج الزمن الوهمي:
/// مؤقّتات Drift لا تنتهي إلا بإزالة الشجرة وإغلاق القاعدة.
///
/// [seed] يُنفَّذ قبل تشغيل التطبيق لتجهيز ملفات جاهزة على «الجهاز».
/// [overrides] لاستبدال خدمات النظام (مثل المشاركة) بنسخ اختبارية.
Future<void> scenario(
  WidgetTester tester,
  Future<void> Function(AppDatabase db) body, {
  Future<void> Function(ProfileRepository repo)? seed,
  List<Override> overrides = const [],
}) async {
  final db = AppDatabase(NativeDatabase.memory());
  if (seed != null) {
    await tester.runAsync(() => seed(ProfileRepository(db)));
  }
  await tester.binding.setSurfaceSize(const Size(390, 1200));
  // go_router يبدأ من مسار المنصّة الافتراضي، وهو يبقى من الاختبار السابق
  // (مثل /home) ما لم نُعد ضبطه.
  tester.platformDispatcher.defaultRouteNameTestValue = '/';
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        catalogRepositoryProvider.overrideWithValue(
          CatalogRepository(loadString: (_) async => _catalogJson),
        ),
        ...overrides,
      ],
      child: const RizmaApp(),
    ),
  );
  await tester.pumpAndSettle();
  try {
    await body(db);
  } finally {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    await tester.runAsync(db.close);
    await tester.binding.setSurfaceSize(null);
    tester.platformDispatcher.clearDefaultRouteNameTestValue();
  }
}

/// ينفّذ عملية على قاعدة البيانات خارج الزمن الوهمي ثم يترك الواجهة تتحدّث.
Future<T> onDb<T>(WidgetTester tester, Future<T> Function() action) async {
  final result = (await tester.runAsync(action)) as T;
  await tester.pumpAndSettle();
  return result;
}

/// يكتب [digits] على لوحة الأرقام ثم ينتظر انتهاء التحقق.
Future<void> enterPin(WidgetTester tester, String digits) async {
  for (final d in digits.split('')) {
    // آخر لوحة في الشجرة هي العليا (الورقة السفلية فوق شاشة 27 إن وُجدت).
    await tester.tap(find.text(d).last);
    await tester.pump();
  }
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
}
