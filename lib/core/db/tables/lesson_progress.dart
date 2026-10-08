import 'package:drift/drift.dart';

import '../enums.dart';
import 'profiles.dart';

/// تقدّم كل طالب في كل درس. تُحذف صفوف الطالب مع حذف ملفه.
@DataClassName('LessonProgressEntry')
class LessonProgress extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get lessonId => text()();
  TextColumn get status => textEnum<LessonStatus>()();
  RealColumn get progress => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, lessonId};
}
