/// عدد الأيام المتتالية التي فيها نشاط، محسوبًا من أوقات النشاط (لا يُخزَّن).
///
/// تنتهي السلسلة اليوم إن وُجد نشاط اليوم، وإلا تنتهي أمس (السلسلة ما زالت
/// «حيّة» حتى نهاية اليوم). إن لم يكن هناك نشاط اليوم ولا أمس فالنتيجة 0.
int currentStreak(Iterable<DateTime> activityTimes, DateTime now) {
  DateTime dayOf(DateTime t) => DateTime(t.year, t.month, t.day);

  final days = activityTimes.map(dayOf).toSet();
  var cursor = dayOf(now);
  if (!days.contains(cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
  }

  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    final previous = cursor.subtract(const Duration(days: 1));
    cursor = DateTime(previous.year, previous.month, previous.day);
  }
  return streak;
}
