// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/theme/app_rename.dart';

class CustomButton extends StatefulWidget {
  CustomButton({super.key, required this.onPressed, required this.title});
  void Function()? onPressed;
  String title;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      color: AppColors.primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title, style: AppTextStyles.semiBold14Px),
            SizedBox(width: 5.w),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
