import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile, this.onSettingsTap});

  final ProfileEntity profile;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: AppColors.primaryColor,
          backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null
              ? Text(profile.initials,
                  style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold))
              : null,
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.fullName,
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor)),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 16.sp, color: Colors.amber),
                  SizedBox(width: 4.w),
                  Text('${profile.rating.toStringAsFixed(1)} (${profile.reviewsCount} reviews)',
                      style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor)),
                ],
              ),
            ],
          ),
        ),
        if (onSettingsTap != null)
          IconButton(
            onPressed: onSettingsTap,
            icon: Icon(Icons.settings_outlined, color: AppColors.mediumTextColor),
          ),
      ],
    );
  }
}