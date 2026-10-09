import '../../core/db/app_database.dart';

/// حجم الخط الذي يختاره الطالب. `scale` يُضرب في مقياس النص في كل التطبيق.
enum FontSizeChoice {
  small(0.9),
  medium(1.0),
  large(1.15);

  const FontSizeChoice(this.scale);

  final double scale;
}

/// تفضيلات طالب واحد. القيم الافتراضية هي ما يراه ملف جديد.
class ProfilePrefs {
  const ProfilePrefs({
    this.fontSize = FontSizeChoice.medium,
    this.gameSounds = true,
    this.wifiOnly = true,
    this.autoVideo = false,
  });

  /// يقرأ التفضيلات من خريطة (اسم التفضيل ← نص). أي قيمة ناقصة أو غير مفهومة
  /// ترجع إلى الافتراضي بدل أن تُفشل الشاشة.
  factory ProfilePrefs.fromMap(Map<String, String> raw) {
    bool flag(String key, bool fallback) => switch (raw[key]) {
      'true' => true,
      'false' => false,
      _ => fallback,
    };

    const defaults = ProfilePrefs();
    return ProfilePrefs(
      fontSize: FontSizeChoice.values.firstWhere(
        (c) => c.name == raw[PreferencesRepository.fontSizeKey],
        orElse: () => defaults.fontSize,
      ),
      gameSounds: flag(
        PreferencesRepository.gameSoundsKey,
        defaults.gameSounds,
      ),
      wifiOnly: flag(PreferencesRepository.wifiOnlyKey, defaults.wifiOnly),
      autoVideo: flag(PreferencesRepository.autoVideoKey, defaults.autoVideo),
    );
  }

  final FontSizeChoice fontSize;

  /// أصوات الألعاب. يُحفظ الآن ويُقرأ حين تُبنى الألعاب.
  final bool gameSounds;

  /// التنزيل عبر Wi-Fi فقط. يقرؤه مدير التنزيلات لاحقًا.
  final bool wifiOnly;

  /// تنزيل الفيديو تلقائيًا. يقرؤه مدير التنزيلات لاحقًا.
  final bool autoVideo;
}

/// تفضيلات كل طالب، محفوظة في جدول `app_settings` بمفاتيح `pref.<id>.<name>`.
/// لا نحتاج جدولًا جديدًا ولا ترحيلًا للقاعدة.
class PreferencesRepository {
  PreferencesRepository(this._db);

  final AppDatabase _db;

  static const fontSizeKey = 'fontSize';
  static const gameSoundsKey = 'gameSounds';
  static const wifiOnlyKey = 'wifiOnly';
  static const autoVideoKey = 'autoVideo';

  static String _prefix(String profileId) => 'pref.$profileId.';

  Stream<ProfilePrefs> watch(String profileId) {
    final prefix = _prefix(profileId);
    return _db.settingsDao
        .watchByPrefix(prefix)
        .map(
          (rows) => ProfilePrefs.fromMap({
            for (final e in rows.entries)
              e.key.substring(prefix.length): e.value,
          }),
        );
  }

  Future<ProfilePrefs> read(String profileId) => watch(profileId).first;

  Future<void> setFontSize(String profileId, FontSizeChoice choice) =>
      _write(profileId, fontSizeKey, choice.name);

  Future<void> setGameSounds(String profileId, bool value) =>
      _write(profileId, gameSoundsKey, '$value');

  Future<void> setWifiOnly(String profileId, bool value) =>
      _write(profileId, wifiOnlyKey, '$value');

  Future<void> setAutoVideo(String profileId, bool value) =>
      _write(profileId, autoVideoKey, '$value');

  Future<void> _write(String profileId, String name, String value) {
    return _db.settingsDao.write('${_prefix(profileId)}$name', value);
  }
}
