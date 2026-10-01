import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/common/widget/custum_text_form_field.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class SkillsEditor extends StatefulWidget {
  const SkillsEditor({
    super.key,
    required this.skills,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> skills;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  State<SkillsEditor> createState() => _SkillsEditorState();
}

class _SkillsEditorState extends State<SkillsEditor> {
  final _controller = TextEditingController();

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onAdd(value);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skills I can help with',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor)),
          SizedBox(height: 12.h),
          if (widget.skills.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: widget.skills
                  .map((s) => Chip(
                        label: Text(s, style: TextStyle(fontSize: 12.sp, color: AppColors.primaryColor)),
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        deleteIcon: Icon(Icons.close, size: 16.sp, color: AppColors.primaryColor),
                        onDeleted: () => widget.onRemove(s),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
          if (widget.skills.isNotEmpty) SizedBox(height: 12.h),

          CustomTextField(
            controller: _controller,
            hintText: 'e.g. Flutter, UI/UX...',
            suffixIcon: IconButton(
              onPressed: _submit,
              icon: Icon(Icons.add_circle, color: AppColors.primaryColor, size: 24.sp),
            ),
            onChanged: (_) {
              return null; // CustomTextField بتاعتك onChanged من نوع String? Function(String)
            },
          ),
        ],
      ),
    );
  }
}