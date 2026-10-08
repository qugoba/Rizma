import '../strings/ar.dart';

/// بيانات الطالب التي تُجمع في شاشة اختيار الصف وتُعرض في الرئيسية.
class StudentProfile {
  const StudentProfile({required this.name, required this.grade});

  final String name;
  final int grade;

  String get gradeLabel => ArStrings.gradeName(grade);
}
