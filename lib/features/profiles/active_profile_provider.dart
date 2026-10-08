import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import 'profile_providers.dart';

/// معرّف الملف النشط المحفوظ على الجهاز (null = لا يوجد).
class ActiveProfileIdNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() {
    return ref.read(profileRepositoryProvider).readActiveId();
  }

  /// يجعل [id] الملف النشط ويحفظه.
  Future<void> select(String id) async {
    await ref.read(profileRepositoryProvider).setActive(id);
    state = AsyncData(id);
  }

  /// يعيد قراءة الملف النشط من القاعدة (بعد إنشاء ملف جديد مثلًا).
  Future<void> reload() async {
    state = AsyncData(await ref.read(profileRepositoryProvider).readActiveId());
  }
}

final activeProfileIdProvider =
    AsyncNotifierProvider<ActiveProfileIdNotifier, String?>(
      ActiveProfileIdNotifier.new,
    );

/// الملف النشط نفسه، ويتحدّث تلقائيًا عند تغيّر بياناته.
final activeProfileProvider = StreamProvider<Profile?>((ref) async* {
  final id = await ref.watch(activeProfileIdProvider.future);
  if (id == null) {
    yield null;
    return;
  }
  yield* ref.watch(profileRepositoryProvider).watchById(id);
});
