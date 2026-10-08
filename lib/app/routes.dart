/// مسارات التنقل، منفصلة عن `router.dart` حتى لا تعتمد الشاشات على الراوتر نفسه.
abstract final class AppRoutes {
  static const welcome = '/';
  static const createProfile = '/create';
  static const home = '/home';
}
