/// بيانات الطالب التي تُجمع في شاشة اختيار الصف وتُعرض في الرئيسية.
class StudentProfile {
  const StudentProfile({required this.name, required this.grade});

  final String name;
  final int grade;

  /// مثال: الصف الخامس
  String get gradeLabel => 'الصف ${_ordinals[grade - 1]}';

  static const _ordinals = [
    'الأول',
    'الثاني',
    'الثالث',
    'الرابع',
    'الخامس',
    'السادس',
    'السابع',
    'الثامن',
    'التاسع',
    'العاشر',
    'الحادي عشر',
    'الثاني عشر',
  ];
}
