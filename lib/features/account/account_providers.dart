import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/database_provider.dart';

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
