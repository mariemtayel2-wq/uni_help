import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
        children: [
          // Header: avatar + name + rating
          Row(
            children: [
              CircleAvatar(radius: 28.r, backgroundColor: AppColors.white),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16.h, width: 140.w, color: AppColors.white),
                    SizedBox(height: 8.h),
                    Container(height: 12.h, width: 100.w, color: AppColors.white),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Skills card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14.h, width: 160.w, color: AppColors.grey),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(
                    4,
                    (_) => Container(
                      height: 28.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(height: 46.h, width: double.infinity, color: AppColors.grey),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // My Requests tile
          Container(
            height: 56.h,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
          ),
          SizedBox(height: 12.h),

          // Help & About tiles
          Container(
            height: 112.h,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
          ),
          SizedBox(height: 16.h),

          // Log out
          Container(
            height: 56.h,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
          ),
        ],
      ),
    );
  }
}