import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/app_settings.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  static const activeProfileKey = 'active_profile_id';

  Future<String?> read(String key) async {
    final row = await (select(
      appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<void> remove(String key) async {
    await (delete(appSettings)..where((s) => s.key.equals(key))).go();
  }
}
