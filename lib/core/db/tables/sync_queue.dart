import 'package:drift/drift.dart';

/// طابور المزامنة. يمتلئ الآن ولا يُرسل؛ الإرسال في مرحلة لاحقة.
@DataClassName('SyncQueueEntry')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get tries => integer().withDefault(const Constant(0))();
}
