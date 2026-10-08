import 'package:drift/drift.dart';

import '../enums.dart';

/// ملف طالب على هذا الجهاز. لا بريد ولا كلمة مرور ولا رقم هاتف.
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  // ignore: recursive_getters
  IntColumn get grade => integer().check(grade.isBetweenValues(1, 12))();
  TextColumn get color => textEnum<ProfileColor>()();

  /// SHA-256 للرمز السري مع salt عشوائي. null = لا رمز سري.
  TextColumn get pinHash => text().nullable()();
  TextColumn get pinSalt => text().nullable()();

  TextColumn get studentCode => text().unique()();
  TextColumn get classCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastActiveAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
