import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/attempts.dart';
import '../tables/concept_mastery.dart';
import '../tables/lesson_progress.dart';
import '../tables/sync_queue.dart';

part 'activity_dao.g.dart';

/// كل ما يخص نشاط الطالب: تقدّم الدروس، المحاولات، الإتقان، وطابور المزامنة.
/// كل الاستعلامات مفلترة بـ `profileId` فلا يرى طالب بيانات أخيه.
@DriftAccessor(tables: [LessonProgress, Attempts, ConceptMastery, SyncQueue])
class ActivityDao extends DatabaseAccessor<AppDatabase>
    with _$ActivityDaoMixin {
  ActivityDao(super.db);

  // تقدّم الدروس
  Stream<List<LessonProgressEntry>> watchLessonProgress(String profileId) {
    return (select(
      lessonProgress,
    )..where((r) => r.profileId.equals(profileId))).watch();
  }

  Future<void> upsertLessonProgress({
    required String profileId,
    required String lessonId,
    required LessonStatus status,
    required double progress,
    required DateTime now,
  }) async {
    await into(lessonProgress).insertOnConflictUpdate(
      LessonProgressCompanion.insert(
        profileId: profileId,
        lessonId: lessonId,
        status: status,
        progress: Value(progress),
        updatedAt: now,
      ),
    );
  }

  // المحاولات
  Stream<List<Attempt>> watchAttempts(String profileId) {
    return (select(
      attempts,
    )..where((a) => a.profileId.equals(profileId))).watch();
  }

  Future<int> insertAttempt({
    required String profileId,
    required String activityId,
    required AttemptKind kind,
    required int score,
    required int total,
    required int starsEarned,
    required DateTime now,
  }) {
    return into(attempts).insert(
      AttemptsCompanion.insert(
        profileId: profileId,
        activityId: activityId,
        kind: kind,
        score: score,
        total: total,
        starsEarned: Value(starsEarned),
        createdAt: now,
      ),
    );
  }

  // الإتقان
  Stream<List<ConceptMasteryEntry>> watchMastery(String profileId) {
    return (select(
      conceptMastery,
    )..where((r) => r.profileId.equals(profileId))).watch();
  }

  Future<void> upsertMastery({
    required String profileId,
    required String conceptId,
    required double mastery,
    required DateTime now,
  }) async {
    await into(conceptMastery).insertOnConflictUpdate(
      ConceptMasteryCompanion.insert(
        profileId: profileId,
        conceptId: conceptId,
        mastery: mastery,
        updatedAt: now,
      ),
    );
  }

  // طابور المزامنة
  Future<void> enqueueSync({
    required String entity,
    required String payloadJson,
    required DateTime now,
  }) async {
    await into(syncQueue).insert(
      SyncQueueCompanion.insert(
        entity: entity,
        payloadJson: payloadJson,
        createdAt: now,
      ),
    );
  }

  Stream<int> watchPendingSyncCount() {
    final countExp = syncQueue.id.count();
    return (selectOnly(syncQueue)..addColumns([countExp]))
        .map((row) => row.read(countExp) ?? 0)
        .watchSingle();
  }
}
