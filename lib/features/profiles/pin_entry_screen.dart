import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/profile_palette.dart';
import '../../core/utils/pin_hasher.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/pin_pad.dart';
import '../../core/widgets/screen_top_bar.dart';
import 'active_profile_provider.dart';
import 'forgot_pin_sheet.dart';
import 'profile_providers.dart';
import 'profile_repository.dart';

/// الشاشة 27 — إدخال الرمز السري لملف محمي.
class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({super.key, required this.profileId});

  final String profileId;

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  String _entry = '';
  bool _wrong = false;
  bool _busy = false;
  int _lockedSeconds = 0;
  Timer? _ticker;

  bool get _isLocked => _lockedSeconds > 0;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_busy || _isLocked || _entry.length >= PinHasher.pinLength) return;
    setState(() {
      _wrong = false;
      _entry += digit;
    });
    if (_entry.length == PinHasher.pinLength) _verify();
  }

  void _onDelete() {
    if (_busy || _entry.isEmpty) return;
    setState(() {
      _wrong = false;
      _entry = _entry.substring(0, _entry.length - 1);
    });
  }

  Future<void> _verify() async {
    setState(() => _busy = true);
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.verifyPin(widget.profileId, _entry);
    if (!mounted) return;

    switch (result.check) {
      case PinCheck.ok:
        await _enter();
      case PinCheck.wrong:
        setState(() {
          _wrong = true;
          _entry = '';
          _busy = false;
        });
      case PinCheck.locked:
        _startCountdown(result.lockedFor ?? const Duration(seconds: 30));
        setState(() {
          _wrong = false;
          _entry = '';
          _busy = false;
        });
    }
  }

  Future<void> _enter() async {
    await ref.read(activeProfileIdProvider.notifier).select(widget.profileId);
    if (mounted) context.go(AppRoutes.home);
  }

  void _startCountdown(Duration duration) {
    _ticker?.cancel();
    _lockedSeconds = (duration.inMilliseconds / 1000).ceil();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _lockedSeconds = (_lockedSeconds - 1).clamp(0, 9999));
      if (_lockedSeconds == 0) timer.cancel();
    });
  }

  Future<void> _forgot() async {
    final profile = ref.read(profileByIdProvider(widget.profileId)).value;
    if (profile == null) return;
    final changed = await showForgotPinSheet(
      context,
      repository: ref.read(profileRepositoryProvider),
      profile: profile,
    );
    if (changed && mounted) await _enter();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileByIdProvider(widget.profileId)).value;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 4),
                  child: BackTile(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.profiles),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
                child: profile == null
                    ? const SizedBox.shrink()
                    : Column(
                        spacing: 14,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: profile.color.avatarBackground,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Mascot(size: 84, color: profile.color),
                          ),
                          Text(
                            ArStrings.pinHello(profile.name),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title26,
                          ),
                          Text(
                            ArStrings.pinEnterTitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body15.copyWith(
                              color: AppColors.soft,
                            ),
                          ),
                          PinDots(
                            length: PinHasher.pinLength,
                            filled: _entry.length,
                            error: _wrong,
                          ),
                          _StatusMessage(
                            wrong: _wrong,
                            lockedSeconds: _lockedSeconds,
                          ),
                          PinPad(
                            onDigit: _onDigit,
                            onDelete: _onDelete,
                            enabled: !_isLocked && !_busy,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _forgot,
                            child: Text(
                              ArStrings.pinForgot,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.label14.copyWith(
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.wrong, required this.lockedSeconds});

  final bool wrong;
  final int lockedSeconds;

  @override
  Widget build(BuildContext context) {
    final text = lockedSeconds > 0
        ? ArStrings.pinLocked(lockedSeconds)
        : (wrong ? ArStrings.pinWrong : null);

    return SizedBox(
      height: 24,
      child: text == null
          ? null
          : Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.label14.copyWith(color: AppColors.coral),
            ),
    );
  }
}
