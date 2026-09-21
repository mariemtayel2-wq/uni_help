import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/utils/time_ago.dart';
import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, this.onTap, this.onMoreTap, super.key});

  final RequestEntity request;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    request.category,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                  ),
                ),
                InkWell(
                  onTap: onMoreTap,
                  child: Icon(Icons.more_vert, size: 20.sp, color: AppColors.mediumTextColor),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              request.title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
            ),
            SizedBox(height: 4.h),
            Text(
              request.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor, height: 1.4),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    request.requesterInitials,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.requesterName,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber),
                          SizedBox(width: 2.w),
                          Text(
                            '${request.requesterRating.toStringAsFixed(1)} (${request.requesterRatingCount})',
                            style: TextStyle(fontSize: 12.sp, color: AppColors.mediumTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (request.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 6.w,
                    children: request.tags
                        .take(2)
                        .map(
                          (tag) => Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(tag, style: TextStyle(fontSize: 11.sp, color: AppColors.mediumTextColor)),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  timeAgo(request.createdAt),
                  style: TextStyle(fontSize: 11.sp, color: AppColors.mediumTextColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}