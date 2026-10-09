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

  // شاشة «من يتعلّم الآن؟» (25)
  static const pickerTitle = 'من يتعلّم الآن؟';
  static const pickerSubtitle = 'اختر ملفك لتكمل من حيث توقفت.';
  static const pickerNewTitle = 'طالب جديد';
  static const pickerNewSubtitle = 'أضف ملفًا لأخ أو أخت';
  static const pickerRestoreTitle = 'لديك رمز طالب؟';
  static const pickerRestoreSubtitle = 'استعد تقدّمك على هذا الجهاز';
  static const pickerPrivacy =
      'الملفات محفوظة على هذا الجهاز · لا نطلب بريدًا ولا رقم هاتف';
  static const restoreNeedsInternet =
      'الاستعادة تحتاج اتصالًا بالإنترنت وستتوفّر قريبًا.';
  static const profileProtected = 'محمي برمز سري';

  static String profileSemantics(String name, String grade, bool locked) =>
      locked ? '$name، $grade، $profileProtected' : '$name، $grade';

  /// «نجمة واحدة / نجمتان / 3 نجوم … 10 نجوم / 11 نجمة».
  static String stars(int n) {
    if (n == 0) return '0 نجوم';
    if (n == 1) return 'نجمة واحدة';
    if (n == 2) return 'نجمتان';
    if (n >= 3 && n <= 10) return '$n نجوم';
    return '$n نجمة';
  }

  /// «يوم واحد / يومان / 3 أيام … 10 أيام / 11 يومًا» + «متتالية».
  static String streakDays(int n) {
    if (n == 1) return 'يوم واحد متتالٍ';
    if (n == 2) return 'يومان متتاليان';
    if (n >= 3 && n <= 10) return '$n أيام متتالية';
    return '$n يومًا متتاليًا';
  }

  // شاشة الرمز السري (27)
  static const pinEnterTitle = 'أدخل رمزك السري';
  static const pinForgot = 'نسيت الرمز؟ استخدم رمز الطالب لإعادة تعيينه';
  static const pinWrong = 'الرمز غير صحيح، حاول مرة أخرى.';

  static String pinHello(String name) => 'مرحبًا $name';
  static String pinLocked(int seconds) =>
      'تجاوزت عدد المحاولات. حاول بعد $seconds ثانية.';

  // استعادة الوصول بدل الرمز المنسي
  static const forgotTitle = 'استعادة الوصول';
  static const forgotCodeLabel = 'أدخل رمز الطالب';
  static const forgotCodeHint = 'RZ-XXXX';
  static const forgotCodeWrong = 'رمز الطالب غير صحيح.';
  static const forgotVerify = 'تحقّق';
  static const forgotChoose = 'تم التحقق. ماذا تريد أن تفعل؟';
  static const forgotSetNew = 'تعيين رمز سري جديد';
  static const forgotRemove = 'إلغاء الرمز السري';

  // الرئيسية (03) وأول يوم (28)
  static const homeAskToday = 'ماذا تريد أن تتعلم اليوم؟';
  static const homeFirstDaySubtitle = 'يومك الأول في رِزمة. لنبدأ معًا!';
  static const homeStartLesson = 'ابدأ الدرس';
  static const homeContinue = 'متابعة التعلم';
  static const homeFirstSteps = 'خطواتك الأولى';
  static const homeStepDownload = 'نزّل أول درس';
  static const homeStepDownloadHint = 'لتتعلّم حتى دون إنترنت';
  static const homeStepPractice = 'أكمل أول تدريب';
  static const homeStepPracticeHint = 'واربح نجومك الأولى';
  static const homeStepQuiz = 'جرّب أول اختبار';
  static const homeStepQuizHint = 'لتعرف ما تحتاج مراجعته';
  static const homeReviewPlaceholder =
      'ما يحتاج إلى مراجعة سيظهر هنا بعد أول اختبار.';
  static const homeNeedsReview = 'يحتاج إلى مراجعة';
  static const homeReviewButton = 'راجِع';
  static const homeMySubjects = 'موادي';
  static const homeShowAll = 'عرض الكل';
  static const homeNotStarted = 'لم تبدأ';
  static const homeLoadFailed = 'تعذّر تحميل الرئيسية.';
  static const homeLessonSoon = 'مشغّل الدروس قيد الإعداد وسيتوفّر قريبًا.';

  static String homeGreeting(String name) => 'مرحبًا، $name';
  static String homeFirstDayGreeting(String name) => 'أهلًا، $name';
  static String homeStartFirstLesson(String title) => 'ابدأ أول درس: $title';
  static String homeLessonMeta(int minutes) =>
      'نحو $minutes دقيقة · شرح وتدريب قصير';
  static String homeLessonTitle(int order, String title) =>
      'الدرس $order: $title';
  static String homeSubjectUnit(String subject, String unit) =>
      '$subject · $unit';
  static String homeFirstStepsCount(int done) => '$done من 3';
  static String homeMastery(int percent) => 'الإتقان $percent%';

  // الشريط السفلي
  static const navHome = 'الرئيسية';
  static const navSubjects = 'المواد';
  static const navProgress = 'تقدّمي';
  static const navProfile = 'حسابي';
  static const navSectionSoon = 'هذا القسم قيد الإعداد وسيتوفّر قريبًا.';

  // حسابي (19) — مجموعة «الملف»
  static const accountTitle = 'حسابي';
  static const accountProfileGroup = 'الملف';
  static const accountStudentCode = 'رمز الطالب';
  static const accountSwitch = 'تبديل الطالب';
  static const accountPin = 'الرمز السري';
  static const accountPinOff = 'غير مفعّل';
  static const accountPinOn = 'مفعّل';
  static const accountLoadFailed = 'تعذّر تحميل حسابك.';

  static String accountSummary(int grade, int stars) =>
      '${gradeName(grade)} · ${ArStrings.stars(stars)}';

  // حسابي — الدراسة
  static const accountStudyGroup = 'الدراسة';
  static const accountGrade = 'الصف';
  static const accountFontSize = 'حجم الخط';
  static const accountGameSounds = 'أصوات الألعاب';
  static const fontSizeSmall = 'صغير';
  static const fontSizeMedium = 'متوسط';
  static const fontSizeLarge = 'كبير';
  static const fontSheetTitle = 'حجم الخط';
  static const gradeSheetTitle = 'اختر صفّك';

  static String gradeContentSoon(int contentGrade) =>
      'محتوى هذا الصف لم يُضف بعد. ستواصل بمحتوى ${gradeName(contentGrade)} حتى يتوفّر.';
  static String gradeChanged(int grade) =>
      'تم تغيير الصف إلى ${gradeName(grade)}.';

  // حسابي — التنزيل والتخزين
  static const accountStorageGroup = 'التنزيل والتخزين';
  static const accountWifiOnly = 'التنزيل عبر Wi-Fi فقط';
  static const accountAutoVideo = 'تنزيل الفيديو تلقائيًا';
  static const accountManageDownloads = 'إدارة التنزيلات';
  static const accountStorageNote = 'يعمل مع التنزيلات عند توفرها.';
  static const downloadsTitle = 'إدارة التنزيلات';
  static const downloadsEmptyTitle = 'لا توجد تنزيلات بعد';
  static const downloadsEmptyBody =
      'حين تنزّل دروسًا لتتعلّم دون إنترنت ستظهر هنا مع حجمها.';

  // حسابي — عام
  static const accountGeneralGroup = 'عام';
  static const accountNightMode = 'الوضع الليلي';
  static const accountSoon = 'قريبًا';
  static const accountPrivacy = 'الخصوصية: بياناتك تبقى على جهازك';
  static const accountAbout = 'عن رزمة · مبادرة شبابية مجتمعية';
  static const privacyTitle = 'الخصوصية';
  static const privacy1 = 'ملفك وتقدّمك ونجومك محفوظة على هذا الجهاز.';
  static const privacy2 =
      'لا نطلب بريدًا إلكترونيًا ولا رقم هاتف ولا كلمة مرور.';
  static const privacy3 = 'الرمز السري يُحفظ مجزّأً ولا يُحفظ نصًّا.';
  static const aboutTitle = 'عن رزمة';
  static const about1 =
      'رِزمة مبادرة شبابية مجتمعية تحوّل المحتوى الذي يُقرأ إلى تعلّم يُمارس.';
  static const about2 = 'صُمّمت لتعمل دون إنترنت.';
  static const about3 = 'عناوين الدروس الحالية مؤقتة وتنتظر مراجعة معلمين.';
  static const close = 'إغلاق';

  // حذف الملف الشخصي
  static const accountDelete = 'حذف الملف الشخصي';
  static const deleteWarning =
      'سيُحذف هذا الملف نهائيًا من الجهاز ولا يمكن التراجع عن ذلك.';
  static const deleteItem1 = 'نجومك وتقدّمك في الدروس';
  static const deleteItem2 = 'نتائج التدريبات والاختبارات';
  static const deleteItem3 = 'إعداداتك ورمزك السري ورمز الطالب';
  static const deleteConfirm = 'احذف نهائيًا';
  static const deleteCancel = 'تراجع';
  static const deletePinTitle = 'أدخل رمزك السري لتأكيد الحذف';
  static const deleteFailed = 'تعذّر حذف الملف، حاول مرة أخرى.';

  static String deleteTitle(String name) => 'حذف ملف «$name»؟';

  // إدارة الرمز السري من حسابي
  static const pinManageTitle = 'الرمز السري';
  static const pinChange = 'تغيير الرمز';
  static const pinDisable = 'إلغاء الرمز السري';
  static const pinEnabledNote = 'تم تفعيل الرمز السري.';
  static const pinChangedNote = 'تم تغيير الرمز السري.';
  static const pinDisabledNote = 'أُلغي الرمز السري.';

  // رمز الطالب (29)
  static const codeTitle = 'رمز الطالب';
  static const codeYours = 'رمزك';
  static const codeCopy = 'نسخ';
  static const codeShare = 'مشاركة';
  static const codeCopied = 'تم نسخ الرمز.';
  static const codeWhyTitle = 'لماذا هذا الرمز؟';
  static const codeWhy1 = 'انقل تقدّمك إلى جهاز جديد';
  static const codeWhy2 = 'معلمك يضيفك إلى مجموعته';
  static const codeWhy3 = 'لا يحتاج بريدًا ولا رقم هاتف';
  static const codeNeverSynced = 'لم يُحفظ على الإنترنت بعد';
  static const codeNothingPending = 'لا توجد نتائج بانتظار الاتصال';
  static const codeClassGroup = 'مجموعة الصف';
  static const codeKeepSafe =
      'احتفظ بالرمز في مكان آمن، أو اطلب من معلمك تسجيله.';

  static String codePending(int n) => switch (n) {
    1 => 'نتيجة واحدة بانتظار الاتصال',
    2 => 'نتيجتان بانتظار الاتصال',
    >= 3 && <= 10 => '$n نتائج بانتظار الاتصال',
    _ => '$n نتيجة بانتظار الاتصال',
  };
  static String codeClassLine(String code) => 'رمز الصف: $code';
  static String codeShareMessage(String code) => 'رمز الطالب في رِزمة: $code';

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
  static String gradeName(int grade) => 'الصف ${gradeOrdinal(grade)}';

  /// مثال: الخامس
  static String gradeOrdinal(int grade) => _gradeOrdinals[grade - 1];
}
