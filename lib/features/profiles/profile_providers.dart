import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import 'profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.watch(appDatabaseProvider),
    now: ref.watch(clockProvider),
  );
});

/// كل الملفات على الجهاز، الأحدث نشاطًا أولًا.
final profilesProvider = StreamProvider<List<Profile>>((ref) {
  return ref.watch(profileRepositoryProvider).watchAll();
});

/// مجموع نجوم كل ملف (معرّف الملف ← عدد النجوم). الملف بلا محاولات غير موجود.
final starsByProfileProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(appDatabaseProvider).activityDao.watchStarsByProfile();
});

/// ملف واحد بمعرّفه (يتحدّث تلقائيًا). `null` إن لم يعد موجودًا.
final profileByIdProvider = StreamProvider.autoDispose.family<Profile?, String>(
  (ref, id) => ref.watch(profileRepositoryProvider).watchById(id),
);
