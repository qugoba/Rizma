import 'package:drift/drift.dart';

import 'profiles.dart';

/// درجة إتقان الطالب لكل مفهوم (0..1). منها يُبنى قسم «يحتاج إلى مراجعة».
@DataClassName('ConceptMasteryEntry')
class ConceptMastery extends Table {
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get conceptId => text()();
  RealColumn get mastery => real()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, conceptId};
}
