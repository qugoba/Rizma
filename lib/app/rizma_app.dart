import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/strings/ar.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../features/account/account_providers.dart';
import 'router.dart';

/// أقصى عرض للمحتوى (هاتف كبير).
const _maxContentWidth = 480.0;

/// تمرير مرِن (ارتداد خفيف عند الحافة) على كل المنصات، بلا توهّج أزرق على أندرويد.
class _RizmaScrollBehavior extends MaterialScrollBehavior {
  const _RizmaScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

class RizmaApp extends ConsumerWidget {
  const RizmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // حجم الخط الذي اختاره الطالب النشط (1.0 قبل أن تصل التفضيلات).
    final fontScale = ref.watch(activePrefsProvider).value?.fontSize.scale ?? 1;

    return MaterialApp.router(
      title: ArStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      scrollBehavior: const _RizmaScrollBehavior(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // تطبيق هاتف: على شاشة عريضة (كروم/حاسوب لوحي) نحصر العرض في عمود
      // بعرض هاتف بدل أن تتمدّد البطاقات والشريط السفلي على كامل العرض.
      builder: (context, child) {
        // نضرب اختيار الطالب في مقياس النظام فلا نلغي إعداد إمكانية الوصول.
        final media = MediaQuery.of(context);
        final systemScale = media.textScaler.scale(1);

        return ColoredBox(
          color: AppColors.mute,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(systemScale * fontScale),
                ),
                child: child!,
              ),
            ),
          ),
        );
      },
      routerConfig: ref.watch(routerProvider),
    );
  }
}
