import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/models/student_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../home/home_screen.dart';

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
  _GradeGroup(title: 'الصفوف 1–4', hint: 'صور وصوت أكثر', grades: [1, 2, 3, 4]),
  _GradeGroup(
    title: 'الصفوف 5–8',
    hint: 'تدريبات وتقدّم',
    grades: [5, 6, 7, 8],
  ),
  _GradeGroup(
    title: 'الصفوف 9–12',
    hint: 'ملخّصات وامتحانات',
    grades: [9, 10, 11, 12],
  ),
];

/// الشاشة 02 — اختيار الصف
class GradeSelectionScreen extends StatefulWidget {
  const GradeSelectionScreen({super.key});

  @override
  State<GradeSelectionScreen> createState() => _GradeSelectionScreenState();
}

class _GradeSelectionScreenState extends State<GradeSelectionScreen> {
  final _nameController = TextEditingController();
  int? _selectedGrade;

  @override
  void initState() {
    super.initState();
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
    final profile = StudentProfile(
      name: _nameController.text.trim(),
      grade: _selectedGrade!,
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => HomeScreen(profile: profile)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(onBack: () => Navigator.of(context).maybePop()),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                      'يمكنك تغيير الصف لاحقًا من حسابك.',
                      style: AppTextStyles.caption13,
                    ),
                    PrimaryButton(
                      label: _selectedGrade == null
                          ? 'متابعة'
                          : 'متابعة · الصف $_selectedGrade',
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        spacing: 12,
        children: [
          Semantics(
            button: true,
            label: 'رجوع',
            excludeSemantics: true,
            child: Material(
              color: AppColors.mute,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onBack,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.back,
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('خطوة 1 من 2', style: AppTextStyles.caption13),
                Text('اختر صفّك', style: AppTextStyles.heading22),
              ],
            ),
          ),
          SvgPicture.asset(AppAssets.mascot56, width: 56, height: 56),
        ],
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
        Text('ما اسمك؟', style: AppTextStyles.body16Strong),
        SizedBox(
          height: 52,
          child: TextField(
            controller: controller,
            style: AppTextStyles.input17,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            cursorColor: AppColors.teal,
            decoration: InputDecoration(
              hintText: 'اكتب اسمك',
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
      label: 'الصف $grade',
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
