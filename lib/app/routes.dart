/// مسارات التنقل، منفصلة عن `router.dart` حتى لا تعتمد الشاشات على الراوتر نفسه.
abstract final class AppRoutes {
  static const welcome = '/';
  static const createStep1 = '/create/step1';
  static const createStep2 = '/create/step2';
  static const home = '/home';
}
