import 'package:flutter/material.dart';

/// يُظهر عنصره بتلاشٍ وانزلاق خفيف للأعلى عند أول ظهور. [delay] يؤخّر البداية
/// فيظهر عناصر القائمة تباعًا بدل أن تقفز دفعة واحدة.
///
/// التأخير داخل منحنى واحد (`Interval`) لا مؤقّت منفصل: لا يترك مؤقّتات معلّقة
/// في الاختبارات، ويتوقف فورًا إن أُزيلت الشاشة.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 320),
    this.offset = 14,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// مسافة الانزلاق الابتدائية بالبكسل (من الأسفل).
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    final total = widget.delay + widget.duration;
    _controller = AnimationController(vsync: this, duration: total);
    _curve = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        widget.delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _curve.value) * widget.offset),
          child: child,
        ),
      ),
    );
  }
}

/// اختصار: `widget.fadeIn(2)` يُظهر الودجت بتلاشٍ وانزلاق بعد `2 × 45` ملّي ثانية،
/// فتظهر عناصر الصفحة تباعًا. لا يضيف مستوى تداخل في الكود.
extension FadeInWidget on Widget {
  Widget fadeIn([int order = 0]) => FadeSlideIn(
    delay: Duration(milliseconds: 45 * order),
    child: this,
  );
}
