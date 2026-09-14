import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.filled,
    this.obscureText,
    this.readOnly = false,
    super.key,
    this.validator,
    this.fillColour,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.overrideValidator = false,
    this.prefixText,
    this.prefix,
    this.prefixIcon,
    this.onChanged,
    this.maxLength,
    this.maxLines = 1,
  });

  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;
  final TextEditingController controller;
  final bool? filled;
  final Color? fillColour;
  final bool? obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? prefixText;
  final Widget? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final TextStyle? hintStyle;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.primaryColor,
      controller: controller,

      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.mediumTextColor,
      ),
      validator: validator,
      onChanged: onChanged,

      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.mediumTextColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.mediumTextColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        filled: filled,
        fillColor: fillColour,
        suffixIcon: suffixIcon,

        prefixIcon: prefixIcon,
        prefixText: prefixText != null ? prefixText.toString() : null,
        prefix: prefix,

        prefixIconConstraints: BoxConstraints(minWidth: 50.w, minHeight: 50.h),

        hintText: hintText,
        hintStyle:
            hintStyle ??
            Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.mediumTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.errorColor,
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
