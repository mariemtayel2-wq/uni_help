import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni_help/core/theme/app_colors.dart';

Widget navIcon({
  required String path,
  required bool isSelected,
}) {
  return AnimatedScale(
    duration: const Duration(milliseconds: 200),
    scale: isSelected ? 1.2 : 1,
    curve: Curves.easeInOut,
    child: SvgPicture.asset(
      path,
      width: 21.w,
      height: 18.h,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.primaryColor : AppColors.mediumTextColor,
        BlendMode.srcIn,
      ),
    ),
  );
}