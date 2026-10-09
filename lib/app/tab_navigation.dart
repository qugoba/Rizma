import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/strings/ar.dart';
import '../core/widgets/bottom_nav.dart';
import 'routes.dart';

/// ما يحدث عند ضغط تبويب في الشريط السفلي. شاشات «المواد» و«تقدّمي» لم تُبنَ
/// بعد، فنخبر الطالب بدل أن نتجاهل الضغطة بصمت.
void onTabSelected(BuildContext context, RizmaTab current, RizmaTab target) {
  if (target == current) return;
  switch (target) {
    case RizmaTab.home:
      context.go(AppRoutes.home);
    case RizmaTab.profile:
      context.go(AppRoutes.account);
    case RizmaTab.subjects:
    case RizmaTab.progress:
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(ArStrings.navSectionSoon)));
  }
}
