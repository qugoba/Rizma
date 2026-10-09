import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizma/core/db/app_database.dart';
import 'package:rizma/features/account/preferences_repository.dart';
import 'package:rizma/features/profiles/profile_repository.dart';

void main() {
  late AppDatabase db;
  late PreferencesRepository prefs;
  late ProfileRepository profiles;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    prefs = PreferencesRepository(db);
    profiles = ProfileRepository(db);
  });

  tearDown(() => db.close());

  group('ProfilePrefs.fromMap', () {
    test('الخريطة الفارغة تعطي الافتراضيات', () {
      final p = ProfilePrefs.fromMap({});
      expect(p.fontSize, FontSizeChoice.medium);
      expect(p.gameSounds, isTrue);
      expect(p.wifiOnly, isTrue);
      expect(p.autoVideo, isFalse);
    });

    test('قيمة غير مفهومة ترجع إلى الافتراضي بدل أن تفشل', () {
      final p = ProfilePrefs.fromMap({
        'fontSize': 'huge',
        'gameSounds': 'maybe',
        'wifiOnly': '',
      });
      expect(p.fontSize, FontSizeChoice.medium);
      expect(p.gameSounds, isTrue);
      expect(p.wifiOnly, isTrue);
    });

    test('مقاييس الخط', () {
      expect(FontSizeChoice.small.scale, lessThan(1));
      expect(FontSizeChoice.medium.scale, 1);
      expect(FontSizeChoice.large.scale, greaterThan(1));
    });
  });

  group('PreferencesRepository', () {
    test('ملف جديد: الافتراضيات', () async {
      final p = await prefs.read('p1');
      expect(p.gameSounds, isTrue);
      expect(p.wifiOnly, isTrue);
      expect(p.autoVideo, isFalse);
    });

    test('يحفظ كل تفضيل ويقرؤه', () async {
      await prefs.setFontSize('p1', FontSizeChoice.large);
      await prefs.setGameSounds('p1', false);
      await prefs.setWifiOnly('p1', false);
      await prefs.setAutoVideo('p1', true);

      final p = await prefs.read('p1');
      expect(p.fontSize, FontSizeChoice.large);
      expect(p.gameSounds, isFalse);
      expect(p.wifiOnly, isFalse);
      expect(p.autoVideo, isTrue);
    });

    test('التفضيلات منفصلة لكل طالب', () async {
      await prefs.setFontSize('a', FontSizeChoice.large);
      await prefs.setAutoVideo('a', true);

      final b = await prefs.read('b');
      expect(b.fontSize, FontSizeChoice.medium);
      expect(b.autoVideo, isFalse);
    });

    test('البث يتحدّث عند كل تغيير', () async {
      final emitted = <FontSizeChoice>[];
      final sub = prefs.watch('p1').listen((p) => emitted.add(p.fontSize));
      await pumpEventQueue();
      await prefs.setFontSize('p1', FontSizeChoice.small);
      await pumpEventQueue();
      await sub.cancel();

      expect(emitted.first, FontSizeChoice.medium);
      expect(emitted.last, FontSizeChoice.small);
    });

    test('معرّف يبدأ بمعرّف آخر لا يتداخل معه', () async {
      await prefs.setWifiOnly('ab', false);
      // 'a' بادئة لـ 'ab' لكن مفتاحيهما مختلفان: pref.a. و pref.ab.
      expect((await prefs.read('a')).wifiOnly, isTrue);
    });
  });

  group('ProfileRepository.setGrade', () {
    test('يغيّر الصف ويُبقي بقية الملف', () async {
      final p = await profiles.create(
        name: 'أنس',
        grade: 5,
        color: ProfileColor.teal,
      );
      await profiles.setGrade(p.id, 7);

      final after = (await profiles.getById(p.id))!;
      expect(after.grade, 7);
      expect(after.name, 'أنس');
      expect(after.studentCode, p.studentCode);
    });

    test('يرفض صفًّا خارج 1–12', () async {
      final p = await profiles.create(
        name: 'أنس',
        grade: 5,
        color: ProfileColor.teal,
      );
      expect(() => profiles.setGrade(p.id, 0), throwsArgumentError);
      expect(() => profiles.setGrade(p.id, 13), throwsArgumentError);
    });
  });
}
