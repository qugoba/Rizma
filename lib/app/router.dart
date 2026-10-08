import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/onboarding/create_profile_draft.dart';
import '../features/onboarding/create_profile_step1_screen.dart';
import '../features/onboarding/create_profile_step2_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.createStep1,
        builder: (context, state) => const CreateProfileStep1Screen(),
      ),
      GoRoute(
        path: AppRoutes.createStep2,
        // بلا بيانات الخطوة 1 لا معنى للخطوة 2 (مثلًا بعد إعادة فتح التطبيق).
        redirect: (context, state) =>
            ref.read(createProfileDraftProvider) == null
            ? AppRoutes.createStep1
            : null,
        builder: (context, state) => const CreateProfileStep2Screen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
