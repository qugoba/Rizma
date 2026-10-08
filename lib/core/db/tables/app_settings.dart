import 'package:drift/drift.dart';

/// إعدادات عامة للجهاز على شكل مفتاح/قيمة (مثل الملف النشط الأخير).
@DataClassName('AppSetting')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
