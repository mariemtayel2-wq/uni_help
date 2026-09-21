import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/home_screen/presentation/view/utils/request_shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Shimmer
              Container(
                width: 120.w,
                height: 12.h,
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(4.r)),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 210.w,
                height: 18.h,
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(4.r)),
              ),
              SizedBox(height: 20.h),

              // Search Bar Shimmer
              Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
              ),
              SizedBox(height: 16.h),

              // Category Chips Shimmer
              SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, __) => Container(
                    width: 75.w,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Title Row Shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 130.w,
                    height: 16.h,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r)),
                  ),
                  Container(
                    width: 50.w,
                    height: 14.h,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.r)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),

        // List of Request Cards Shimmer
        ...List.generate(3, (_) => const RequestCardShimmer()),
      ],
    );
  }
}