import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/common/widget/loading_shimmer.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class CreateRequestLoadingSkeleton extends StatelessWidget {
  const CreateRequestLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(12.w),
          child: const LoadingShimmer(
            width: 20,
            height: 20,
            borderRadius: 6,
          ),
        ),
        title: LoadingShimmer(
          width: 140.w,
          height: 20.h,
          borderRadius: 6.r,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Skeleton
            _buildFieldSkeleton(height: 48.h, labelWidth: 60.w),
            SizedBox(height: 16.h),

            // Description Skeleton
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingShimmer(width: 90.w, height: 16.h, borderRadius: 4.r),
                    LoadingShimmer(width: 40.w, height: 14.h, borderRadius: 4.r),
                  ],
                ),
                SizedBox(height: 8.h),
                LoadingShimmer(width: double.infinity, height: 110.h, borderRadius: 12.r),
              ],
            ),
            SizedBox(height: 16.h),

            // Category Skeleton
            _buildFieldSkeleton(height: 48.h, labelWidth: 80.w),
            SizedBox(height: 16.h),

            // Skill Needed Skeleton
            _buildFieldSkeleton(height: 48.h, labelWidth: 95.w),
            SizedBox(height: 16.h),

            // Attachment Skeleton
            _buildFieldSkeleton(height: 90.h, labelWidth: 110.w),
            SizedBox(height: 16.h),

            // Preferred Time Skeleton
            _buildFieldSkeleton(height: 48.h, labelWidth: 100.w),
            SizedBox(height: 32.h),

            // Button Skeleton
            LoadingShimmer(
              width: double.infinity,
              height: 48.h,
              borderRadius: 24.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldSkeleton({required double height, required double labelWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadingShimmer(width: labelWidth, height: 16.h, borderRadius: 4.r),
        SizedBox(height: 8.h),
        LoadingShimmer(width: double.infinity, height: height, borderRadius: 12.r),
      ],
    );
  }
}