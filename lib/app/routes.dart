/// مسارات التنقل، منفصلة عن `router.dart` حتى لا تعتمد الشاشات على الراوتر نفسه.
abstract final class AppRoutes {
  /// شاشة إقلاع صامتة تقرر إلى أين نذهب عند فتح التطبيق.
  static const launch = '/';
  static const welcome = '/welcome';
  static const createStep1 = '/create/step1';
  static const createStep2 = '/create/step2';
  static const profiles = '/profiles';
  static const pinPattern = '/pin/:id';
  static const home = '/home';
  static const account = '/account';
  static const studentCode = '/account/code';
  static const downloads = '/account/downloads';

  static String pin(String profileId) => '/pin/$profileId';
}
