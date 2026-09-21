import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_help/features/home_screen/presentation/view/utils/request_shimmer.dart'; // مسار الـ RequestCardShimmer الذي أنشأناه سابقاً

class ExploreScreenShimmer extends StatelessWidget {
  const ExploreScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 80.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 120.h),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (_, __) => const RequestCardShimmer(),
          ),
        ),
      ],
    );
  }
}