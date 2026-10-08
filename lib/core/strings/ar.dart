import '../db/enums.dart';

/// كل النصوص الظاهرة للمستخدم في مكان واحد، تمهيدًا للترجمة لاحقًا.
abstract final class ArStrings {
  static const appName = 'رِزمة';

  // عام
  static const back = 'رجوع';
  static const continueLabel = 'متابعة';

  // الترحيب
  static const welcomeTagline =
      'من المحتوى الذي يُقرأ… إلى التعلم الذي يُمارس.';
  static const welcomeValue1Title = 'رزمتك… بطريقة أوضح';
  static const welcomeValue1Subtitle = 'شرح، ملخص، فيديو وتدريب لكل درس.';
  static const welcomeValue2Title = 'تعلّم دون إنترنت';
  static const welcomeValue2Subtitle = 'نزّل الدرس مرة وتعلّم في أي وقت.';
  static const welcomeValue3Title = 'اعرف أين تحتاج مراجعة';
  static const welcomeValue3Subtitle = 'خطة قصيرة مبنية على نتيجتك.';
  static const welcomeStart = 'ابدأ';
  static const welcomeHaveProfile = 'لديّ ملف طالب على هذا الجهاز';

  // اختيار الصف (الخطوة 1 من 2)
  static const gradeStep = 'خطوة 1 من 2';
  static const gradeTitle = 'اختر صفّك';
  static const nameLabel = 'ما اسمك؟';
  static const nameHint = 'اكتب اسمك';
  static const gradeGroup14 = 'الصفوف 1–4';
  static const gradeGroup14Hint = 'صور وصوت أكثر';
  static const gradeGroup58 = 'الصفوف 5–8';
  static const gradeGroup58Hint = 'تدريبات وتقدّم';
  static const gradeGroup912 = 'الصفوف 9–12';
  static const gradeGroup912Hint = 'ملخّصات وامتحانات';
  static const gradeChangeLater = 'يمكنك تغيير الصف لاحقًا من حسابك.';

  static String continueWithGrade(int grade) => 'متابعة · الصف $grade';
  static String gradeSemantics(int grade) => 'الصف $grade';

  // إعداد الملف (الخطوة 2 من 2)
  static const setupStep = 'خطوة 2 من 2';
  static const setupTitle = 'اجعل الملف لك';
  static const setupPickColor = 'اختر لون شخصيتك';
  static const setupPinTitle = 'رمز سري';
  static const setupPinSubtitle = 'يمنع الآخرين من فتح ملفك على هذا الجهاز';
  static const setupPinSwitch = 'تفعيل الرمز السري';
  static const setupPinHint = 'اختياري · يُنصح به للصفوف 7–12';
  static const setupClassTitle = 'رمز الصف (اختياري)';
  static const setupClassSubtitle = 'يعطيك إياه معلمك لتنضم إلى مجموعته';
  static const setupClassHint = 'مثال: GZ-5A';
  static const setupClassInvalid =
      'رمز الصف غير صحيح. استخدم حروفًا إنجليزية وأرقامًا وشرطة، مثل GZ-5A.';
  static const setupStart = 'ابدأ التعلّم';
  static const setupChangeLater = 'يمكنك تغيير كل هذا لاحقًا من حسابك.';
  static const setupCreateFailed = 'تعذّر إنشاء الملف، حاول مرة أخرى.';

  static String setupPreview(String name, int grade) =>
      '$name · ${gradeName(grade)}';

  static String colorName(ProfileColor color) => switch (color) {
    ProfileColor.teal => 'أخضر',
    ProfileColor.coral => 'مرجاني',
    ProfileColor.blue => 'أزرق',
    ProfileColor.purple => 'بنفسجي',
    ProfileColor.amber => 'عنبري',
  };

  // لوحة الرمز السري
  static const pinSetupTitle = 'اختر رمزًا سريًّا من 4 أرقام';
  static const pinConfirmTitle = 'أعد إدخال الرمز للتأكيد';
  static const pinMismatch = 'الرمزان غير متطابقين، حاول مرة أخرى.';
  static const pinDelete = 'حذف';

  static String pinDotsSemantics(int filled, int length) =>
      'أُدخل $filled من $length أرقام';

  // الرئيسية
  static const homeAskToday = 'ماذا تريد أن تتعلم اليوم؟';

  static String homeGreeting(String name) => 'مرحبًا، $name';

  // الشريط السفلي
  static const navHome = 'الرئيسية';
  static const navSubjects = 'المواد';
  static const navProgress = 'تقدّمي';
  static const navProfile = 'حسابي';

  // أسماء الصفوف
  static const _gradeOrdinals = [
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

  /// مثال: الصف الخامس
  static String gradeName(int grade) => 'الصف ${_gradeOrdinals[grade - 1]}';
}
