import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/activity_dao.dart';
import 'daos/profiles_dao.dart';
import 'daos/settings_dao.dart';
import 'enums.dart';
import 'tables/app_settings.dart';
import 'tables/attempts.dart';
import 'tables/concept_mastery.dart';
import 'tables/lesson_progress.dart';
import 'tables/profiles.dart';
import 'tables/sync_queue.dart';

export 'enums.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Profiles,
    LessonProgress,
    Attempts,
    ConceptMastery,
    SyncQueue,
    AppSettings,
  ],
  daos: [ProfilesDao, ActivityDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// قاعدة البيانات الحقيقية على الجهاز (SQLite).
  AppDatabase.onDevice()
    : super(
        driftDatabase(
          name: 'rizma',
          // الويب فقط (للتطوير على Chrome): يحتاج الملفين في مجلد web/.
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // بدونها لا يعمل الحذف المتسلسل عند حذف ملف طالب.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
