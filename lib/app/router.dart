import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models/student_profile.dart';
import '../features/grade_selection/grade_selection_screen.dart';
import '../features/home/home_screen.dart';
import '../features/welcome/welcome_screen.dart';
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
        path: AppRoutes.createProfile,
        builder: (context, state) => const GradeSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (context, state) =>
            state.extra is StudentProfile ? null : AppRoutes.welcome,
        builder: (context, state) =>
            HomeScreen(profile: state.extra! as StudentProfile),
      ),
    ],
  );
});
