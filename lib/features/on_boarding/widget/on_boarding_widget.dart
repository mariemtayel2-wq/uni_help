import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/animation/animate_do.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/theme/app_rename.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.disc,
  });
  final String imagePath;
  final String title;
  final String disc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomFadeInDown(child: Image.asset(imagePath, height: 300)),
        CustomFadeInUp(
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: AppTextStyles.bold28Px.copyWith(
              color: AppColors.largeTextColor,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        CustomFadeInUp(
          child: Text(
            textAlign: TextAlign.center,

            disc,
            style: AppTextStyles.regular16Px.copyWith(
              color: AppColors.mediumTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
