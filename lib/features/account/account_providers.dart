import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/database_provider.dart';
import '../profiles/active_profile_provider.dart';
import 'preferences_repository.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(ref.watch(appDatabaseProvider));
});

/// تفضيلات الملف النشط (تتحدّث فور تغييرها). بلا ملف نشط: الافتراضيات.
final activePrefsProvider = StreamProvider<ProfilePrefs>((ref) async* {
  final id = await ref.watch(activeProfileIdProvider.future);
  if (id == null) {
    yield const ProfilePrefs();
    return;
  }
  yield* ref.watch(preferencesRepositoryProvider).watch(id);
});

/// عدد النتائج المحفوظة على الجهاز وتنتظر الإرسال (طابور المزامنة).
final pendingSyncCountProvider = StreamProvider.autoDispose<int>((ref) {
  return ref.watch(appDatabaseProvider).activityDao.watchPendingSyncCount();
});

/// يشارك نصًّا عبر نافذة المشاركة في النظام.
typedef ShareText = Future<void> Function(String text);

/// منفصل كمزوّد ليُستبدل في الاختبارات (نافذة النظام لا تعمل فيها).
final shareTextProvider = Provider<ShareText>((ref) {
  return (text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  };
});
