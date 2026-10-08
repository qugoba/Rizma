import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../profiles/profile_providers.dart';

enum LaunchTarget {
  /// لا توجد ملفات: ابدأ من الترحيب وإنشاء الملف.
  welcome,

  /// ملف واحد بلا رمز سري: ادخل الرئيسية مباشرة.
  home,

  /// أكثر من ملف أو ملف محمي برمز سري: اختر من يتعلّم.
  picker,
}

class LaunchPlan {
  const LaunchPlan(this.target, {this.profileId});

  final LaunchTarget target;

  /// الملف الذي يُفتح مباشرة عند `home`.
  final String? profileId;
}

/// قواعد التنقل عند فتح التطبيق (دالة صرفة لتسهل اختبارها):
/// 1. لا ملفات ← الترحيب.
/// 2. ملف واحد بلا رمز سري ← الرئيسية.
/// 3. غير ذلك ← «من يتعلّم الآن؟».
LaunchPlan decideLaunchPlan(List<Profile> profiles) {
  if (profiles.isEmpty) return const LaunchPlan(LaunchTarget.welcome);
  if (profiles.length == 1 && profiles.single.pinHash == null) {
    return LaunchPlan(LaunchTarget.home, profileId: profiles.single.id);
  }
  return const LaunchPlan(LaunchTarget.picker);
}

/// يُعاد حسابها كل مرة تُفتح فيها شاشة الإقلاع (autoDispose).
final launchPlanProvider = FutureProvider.autoDispose<LaunchPlan>((ref) async {
  final profiles = await ref.read(profileRepositoryProvider).getAll();
  return decideLaunchPlan(profiles);
});
