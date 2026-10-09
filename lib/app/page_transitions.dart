import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// نوع حركة الانتقال بين الشاشات.
enum PageMotion {
  /// شاشات التبويبات (الرئيسية، حسابي): تلاشٍ سريع بلا انزلاق، فلا يبدو
  /// التنقّل بينها كأنه دخول إلى شاشة أعمق.
  tab,

  /// شاشات تُفتح فوق غيرها: تلاشٍ مع انزلاق خفيف من جهة القراءة.
  push,
}

/// صفحة بحركة انتقال مخصّصة بدل الحركة الافتراضية للنظام.
CustomTransitionPage<void> appPage({
  required GoRouterState state,
  required Widget child,
  PageMotion motion = PageMotion.push,
}) {
  final isTab = motion == PageMotion.tab;
  final duration = Duration(milliseconds: isTab ? 180 : 260);

  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final faded = FadeTransition(opacity: curved, child: child);
      if (isTab) return faded;

      // «نحو الأمام» في RTL يعني من اليسار، وفي LTR من اليمين.
      final rtl = Directionality.of(context) == TextDirection.rtl;
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(rtl ? -0.06 : 0.06, 0),
          end: Offset.zero,
        ).animate(curved),
        child: faded,
      );
    },
  );
}
