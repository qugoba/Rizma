import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// قاعدة البيانات الوحيدة للتطبيق. تُستبدل في الاختبارات بقاعدة في الذاكرة.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.onDevice();
  ref.onDispose(db.close);
  return db;
});

/// الساعة الحالية، قابلة للاستبدال في الاختبارات.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
