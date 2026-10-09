import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/strings/ar.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

/// أقصى عرض للمحتوى (هاتف كبير).
const _maxContentWidth = 480.0;

class RizmaApp extends ConsumerWidget {
  const RizmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: ArStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // تطبيق هاتف: على شاشة عريضة (كروم/حاسوب لوحي) نحصر العرض في عمود
      // بعرض هاتف بدل أن تتمدّد البطاقات والشريط السفلي على كامل العرض.
      builder: (context, child) => ColoredBox(
        color: AppColors.mute,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: child,
          ),
        ),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
