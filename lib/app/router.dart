import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/account_screen.dart';
import '../features/account/downloads_screen.dart';
import '../features/account/student_code_screen.dart';
import '../features/home/home_screen.dart';
import '../features/launch/launch_screen.dart';
import '../features/onboarding/create_profile_draft.dart';
import '../features/onboarding/create_profile_step1_screen.dart';
import '../features/onboarding/create_profile_step2_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import '../features/profiles/active_profile_provider.dart';
import '../features/profiles/pin_entry_screen.dart';
import '../features/profiles/profile_picker_screen.dart';
import 'page_transitions.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  String? requireActiveProfile(BuildContext context, GoRouterState state) {
    final active = ref.read(activeProfileIdProvider);
    return active.hasValue && active.value == null ? AppRoutes.launch : null;
  }

  return GoRouter(
    initialLocation: AppRoutes.launch,
    routes: [
      // تقرر الوجهة عند فتح التطبيق (انظر launch_plan.dart).
      GoRoute(
        path: AppRoutes.launch,
        pageBuilder: (context, state) => appPage(
          state: state,
          child: const LaunchScreen(),
          motion: PageMotion.tab,
        ),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) => appPage(
          state: state,
          child: const WelcomeScreen(),
          motion: PageMotion.tab,
        ),
      ),
      GoRoute(
        path: AppRoutes.createStep1,
        pageBuilder: (context, state) =>
            appPage(state: state, child: const CreateProfileStep1Screen()),
      ),
      GoRoute(
        path: AppRoutes.createStep2,
        // بلا بيانات الخطوة 1 لا معنى للخطوة 2 (مثلًا بعد إعادة فتح التطبيق).
        redirect: (context, state) =>
            ref.read(createProfileDraftProvider) == null
            ? AppRoutes.createStep1
            : null,
        pageBuilder: (context, state) =>
            appPage(state: state, child: const CreateProfileStep2Screen()),
      ),
      GoRoute(
        path: AppRoutes.profiles,
        pageBuilder: (context, state) => appPage(
          state: state,
          child: const ProfilePickerScreen(),
          motion: PageMotion.tab,
        ),
      ),
      GoRoute(
        path: AppRoutes.pinPattern,
        pageBuilder: (context, state) => appPage(
          state: state,
          child: PinEntryScreen(profileId: state.pathParameters['id']!),
        ),
      ),
      // شاشات تحتاج ملفًا نشطًا (مثلًا فتح الرابط مباشرة بلا ملف): نعود
      // لشاشة الإقلاع لتقرر الوجهة.
      GoRoute(
        path: AppRoutes.home,
        redirect: requireActiveProfile,
        pageBuilder: (context, state) => appPage(
          state: state,
          child: const HomeScreen(),
          motion: PageMotion.tab,
        ),
      ),
      GoRoute(
        path: AppRoutes.account,
        redirect: requireActiveProfile,
        pageBuilder: (context, state) => appPage(
          state: state,
          child: const AccountScreen(),
          motion: PageMotion.tab,
        ),
      ),
      GoRoute(
        path: AppRoutes.studentCode,
        redirect: requireActiveProfile,
        pageBuilder: (context, state) =>
            appPage(state: state, child: const StudentCodeScreen()),
      ),
      GoRoute(
        path: AppRoutes.downloads,
        redirect: requireActiveProfile,
        pageBuilder: (context, state) =>
            appPage(state: state, child: const DownloadsScreen()),
      ),
    ],
  );
});
