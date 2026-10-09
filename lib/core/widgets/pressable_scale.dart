import 'package:flutter/material.dart';

/// يصغّر عنصرَه قليلًا أثناء الضغط ثم يعيده، فيشعر الطالب بأن اللمسة «ضغطت»
/// شيئًا. لا يمنع اللمسة ولا يتدخل فيها (يستمع فقط)، فيعمل مع أي `InkWell`.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.scale = 0.97,
    this.enabled = true,
  });

  final Widget child;

  /// مقياس الحجم أثناء الضغط (1 = بلا تغيير).
  final double scale;

  /// إن كان false (زر معطّل) لا يتغيّر الحجم.
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _set(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down && widget.enabled ? widget.scale : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// اختصار: `widget.pressable()` يلفّ الودجت بـ [PressableScale] دون إعادة
/// ترتيب الكود (لا مستوى تداخل إضافي).
extension PressableWidget on Widget {
  Widget pressable({bool enabled = true, double scale = 0.97}) =>
      PressableScale(enabled: enabled, scale: scale, child: this);
}
