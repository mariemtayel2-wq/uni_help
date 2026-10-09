import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : AppColors.largeTextColor;
    return Material(
      color: AppColors.white,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.mediumTextColor,
          size: 22.sp,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isDestructive
            ? null
            : Icon(Icons.chevron_right, color: AppColors.mediumTextColor),
      ),
    );
  }
}
