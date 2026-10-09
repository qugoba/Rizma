import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/db/enums.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/profile_palette.dart';
import '../../core/utils/class_code.dart';
import '../../core/widgets/icon_tile.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rizma_card.dart';
import '../../core/widgets/rizma_switch.dart';
import '../../core/widgets/screen_top_bar.dart';
import '../profiles/active_profile_provider.dart';
import '../profiles/pin_setup_sheet.dart';
import '../profiles/profile_providers.dart';
import 'create_profile_draft.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/utils/haptics.dart';

/// الشاشة 26 — إنشاء الملف، الخطوة 2 من 2: لون الشخصية + رمز سري + رمز الصف.
class CreateProfileStep2Screen extends ConsumerStatefulWidget {
  const CreateProfileStep2Screen({super.key});

  @override
  ConsumerState<CreateProfileStep2Screen> createState() =>
      _CreateProfileStep2ScreenState();
}

class _CreateProfileStep2ScreenState
    extends ConsumerState<CreateProfileStep2Screen> {
  final _classCodeController = TextEditingController();
  ProfileColor _color = ProfileColor.teal;
  String? _pin;
  bool _classCodeInvalid = false;
  bool _submitting = false;

  @override
  void dispose() {
    _classCodeController.dispose();
    super.dispose();
  }

  Future<void> _onPinToggled(bool enabled) async {
    if (!enabled) {
      setState(() => _pin = null);
      return;
    }
    final pin = await showPinSetupSheet(context);
    if (!mounted) return;
    setState(() => _pin = pin);
  }

  Future<void> _submit() async {
    final draft = ref.read(createProfileDraftProvider);
    if (draft == null || _submitting) return;

    final rawClassCode = _classCodeController.text;
    if (rawClassCode.trim().isNotEmpty &&
        !ClassCode.isValid(ClassCode.normalize(rawClassCode))) {
      setState(() => _classCodeInvalid = true);
      return;
    }

    setState(() {
      _submitting = true;
      _classCodeInvalid = false;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(profileRepositoryProvider)
          .create(
            name: draft.name,
            grade: draft.grade,
            color: _color,
            pin: _pin,
            classCode: rawClassCode,
          );
      ref.read(createProfileDraftProvider.notifier).clear();
      await ref.read(activeProfileIdProvider.notifier).reload();
      if (mounted) context.go(AppRoutes.home);
    } catch (error, stackTrace) {
      debugPrint('إنشاء الملف فشل: $error\n$stackTrace');
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            // في وضع التطوير نُظهر سبب الخطأ الحقيقي لتسهيل التشخيص.
            kDebugMode
                ? '${ArStrings.setupCreateFailed}\n$error'
                : ArStrings.setupCreateFailed,
          ),
        ),
      );
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(createProfileDraftProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ScreenTopBar(
                subtitle: ArStrings.setupStep,
                title: ArStrings.setupTitle,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.createStep1),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    _Preview(
                      color: _color,
                      label: draft == null
                          ? ''
                          : ArStrings.setupPreview(draft.name, draft.grade),
                    ),
                    _ColorPicker(
                      selected: _color,
                      onSelected: (c) => setState(() => _color = c),
                    ),
                    _PinCard(enabled: _pin != null, onChanged: _onPinToggled),
                    _ClassCodeCard(
                      controller: _classCodeController,
                      invalid: _classCodeInvalid,
                      onChanged: () {
                        if (_classCodeInvalid) {
                          setState(() => _classCodeInvalid = false);
                        }
                      },
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: ArStrings.setupStart,
                      iconAsset: AppAssets.fwdGrade,
                      onPressed: _submitting ? null : _submit,
                    ),
                    Text(
                      ArStrings.setupChangeLater,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption13,
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

class _Preview extends StatelessWidget {
  const _Preview({required this.color, required this.label});

  final ProfileColor color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: color.avatarBackground,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        spacing: 4,
        children: [
          Mascot(size: 96, color: color),
          Text(label, style: AppTextStyles.section18),
        ],
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({required this.selected, required this.onSelected});

  final ProfileColor selected;
  final ValueChanged<ProfileColor> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Text(ArStrings.setupPickColor, style: AppTextStyles.body16Strong),
        // FittedBox: خمس دوائر بعرض 56 لا تتسع في 280، فتتقلّص قليلًا بدل أن تفيض.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 14,
            children: [
              for (final color in ProfileColor.values)
                _ColorDot(
                  color: color,
                  selected: color == selected,
                  onTap: () {
                    Haptics.tap();
                    onSelected(color);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final ProfileColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: ArStrings.colorName(color),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.ink : Colors.transparent,
              width: 3,
            ),
          ),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.body,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ).pressable();
  }
}

class _PinCard extends StatelessWidget {
  const _PinCard({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return RizmaCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            spacing: 12,
            children: [
              const IconTile(
                iconData: Icons.lock_outline_rounded,
                iconColor: AppColors.purple,
                color: AppColors.purpleTint,
                size: 40,
                iconSize: 20,
                radius: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ArStrings.setupPinTitle,
                      style: AppTextStyles.body16Strong,
                    ),
                    Text(
                      ArStrings.setupPinSubtitle,
                      style: AppTextStyles.caption13,
                    ),
                  ],
                ),
              ),
              RizmaSwitch(
                value: enabled,
                onChanged: onChanged,
                semanticsLabel: ArStrings.setupPinSwitch,
              ),
            ],
          ),
          Text(ArStrings.setupPinHint, style: AppTextStyles.caption13),
        ],
      ),
    );
  }
}

class _ClassCodeCard extends StatelessWidget {
  const _ClassCodeCard({
    required this.controller,
    required this.invalid,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool invalid;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final borderColor = invalid ? AppColors.coral : AppColors.line;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: borderColor, width: 2),
    );

    return RizmaCard(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            spacing: 12,
            children: [
              const IconTile(
                iconData: Icons.group_outlined,
                iconColor: AppColors.teal,
                color: AppColors.tealTint,
                size: 40,
                iconSize: 20,
                radius: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ArStrings.setupClassTitle,
                      style: AppTextStyles.body16Strong,
                    ),
                    Text(
                      ArStrings.setupClassSubtitle,
                      style: AppTextStyles.caption13,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged(),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              cursorColor: AppColors.teal,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
                LengthLimitingTextInputFormatter(ClassCode.maxLength),
                TextInputFormatter.withFunction(
                  (old, value) =>
                      value.copyWith(text: value.text.toUpperCase()),
                ),
              ],
              style: AppTextStyles.body15,
              decoration: InputDecoration(
                hintText: ArStrings.setupClassHint,
                hintStyle: AppTextStyles.body15.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.placeholder,
                ),
                filled: true,
                fillColor: AppColors.ground,
                contentPadding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 14,
                ),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: invalid ? AppColors.coral : AppColors.teal,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          if (invalid)
            Text(
              ArStrings.setupClassInvalid,
              style: AppTextStyles.caption13.copyWith(color: AppColors.coral),
            ),
        ],
      ),
    );
  }
}
