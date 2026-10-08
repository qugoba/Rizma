import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/constants/app_assets.dart';
import '../../core/strings/ar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/mascot.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/screen_top_bar.dart';
import 'create_profile_draft.dart';

class _GradeGroup {
  const _GradeGroup({
    required this.title,
    required this.hint,
    required this.grades,
  });

  final String title;
  final String hint;
  final List<int> grades;
}

const _groups = [
  _GradeGroup(
    title: ArStrings.gradeGroup14,
    hint: ArStrings.gradeGroup14Hint,
    grades: [1, 2, 3, 4],
  ),
  _GradeGroup(
    title: ArStrings.gradeGroup58,
    hint: ArStrings.gradeGroup58Hint,
    grades: [5, 6, 7, 8],
  ),
  _GradeGroup(
    title: ArStrings.gradeGroup912,
    hint: ArStrings.gradeGroup912Hint,
    grades: [9, 10, 11, 12],
  ),
];

/// الشاشة 02 — إنشاء الملف، الخطوة 1 من 2: الاسم والصف.
class CreateProfileStep1Screen extends ConsumerStatefulWidget {
  const CreateProfileStep1Screen({super.key});

  @override
  ConsumerState<CreateProfileStep1Screen> createState() =>
      _CreateProfileStep1ScreenState();
}

class _CreateProfileStep1ScreenState
    extends ConsumerState<CreateProfileStep1Screen> {
  final _nameController = TextEditingController();
  int? _selectedGrade;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(createProfileDraftProvider);
    if (draft != null) {
      _nameController.text = draft.name;
      _selectedGrade = draft.grade;
    }
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedGrade != null && _nameController.text.trim().isNotEmpty;

  void _continue() {
    ref
        .read(createProfileDraftProvider.notifier)
        .save(name: _nameController.text.trim(), grade: _selectedGrade!);
    context.push(AppRoutes.createStep2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenTopBar(
                subtitle: ArStrings.gradeStep,
                title: ArStrings.gradeTitle,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.welcome),
                end: const Mascot(size: 56),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    _NameField(controller: _nameController),
                    for (final group in _groups)
                      _GradeGroupSection(
                        group: group,
                        selected: _selectedGrade,
                        onSelected: (grade) =>
                            setState(() => _selectedGrade = grade),
                      ),
                    Text(
                      ArStrings.gradeChangeLater,
                      style: AppTextStyles.caption13,
                    ),
                    PrimaryButton(
                      label: _selectedGrade == null
                          ? ArStrings.continueLabel
                          : ArStrings.continueWithGrade(_selectedGrade!),
                      iconAsset: AppAssets.fwdGrade,
                      onPressed: _canContinue ? _continue : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: AppColors.line, width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Text(ArStrings.nameLabel, style: AppTextStyles.body16Strong),
        SizedBox(
          height: 52,
          child: TextField(
            controller: controller,
            style: AppTextStyles.input17,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            cursorColor: AppColors.teal,
            decoration: InputDecoration(
              hintText: ArStrings.nameHint,
              hintStyle: AppTextStyles.input17.copyWith(
                color: AppColors.disabled,
              ),
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.teal, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradeGroupSection extends StatelessWidget {
  const _GradeGroupSection({
    required this.group,
    required this.selected,
    required this.onSelected,
  });

  final _GradeGroup group;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          spacing: 8,
          children: [
            Text(group.title, style: AppTextStyles.section18),
            Text(group.hint, style: AppTextStyles.caption13),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            for (final grade in group.grades)
              Expanded(
                child: _GradeTile(
                  grade: grade,
                  selected: grade == selected,
                  onTap: () => onSelected(grade),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _GradeTile extends StatelessWidget {
  const _GradeTile({
    required this.grade,
    required this.selected,
    required this.onTap,
  });

  final int grade;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.teal : AppColors.line;

    return Semantics(
      button: true,
      selected: selected,
      label: ArStrings.gradeSemantics(grade),
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 64,
        decoration: BoxDecoration(
          color: selected ? AppColors.teal : AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Center(
              child: Text(
                '$grade',
                style: AppTextStyles.gradeNumber24.copyWith(
                  color: selected ? AppColors.card : AppColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
