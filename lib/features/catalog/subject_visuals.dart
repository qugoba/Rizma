import '../../core/constants/app_assets.dart';

/// يحوّل مفتاح أيقونة المادة في الكتالوج (calc / book / chat / leaf) إلى ملف SVG.
/// الكتالوج يحدّد «ما هي المادة»، والواجهة تحدّد «كيف تُرسم».
String subjectIconAsset(String key) {
  return switch (key) {
    'calc' => AppAssets.calcSubject,
    'book' => AppAssets.bookSubject,
    'chat' => AppAssets.chat,
    'leaf' => AppAssets.leaf,
    _ => AppAssets.bookSubject,
  };
}
