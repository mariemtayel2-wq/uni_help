import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // حدّث رقم الإصدار ده مع كل release (نفس اللي في pubspec.yaml).
  static const _appVersion = '1.0.0';

  static const _features = [
    _FeatureData(
      Icons.edit_note_rounded,
      'Post requests',
      'Ask for help with studying, projects, or anything you need on campus.',
    ),
    _FeatureData(
      Icons.volunteer_activism_rounded,
      'Offer help',
      'Browse requests from other students and offer your skills and time.',
    ),
    _FeatureData(
      Icons.chat_bubble_outline_rounded,
      'Chat in real time',
      'Talk directly with the other student to agree on the details.',
    ),
    _FeatureData(
      Icons.star_outline_rounded,
      'Build trust',
      'Rate each experience so the community knows who to rely on.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.largeTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Uni Help',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            // Header
            Column(
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: Icon(Icons.school_rounded, size: 40.sp, color: Colors.white),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Uni Help',
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Students helping students',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Version $_appVersion',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Who we are
            const _SectionTitle('Who we are'),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14.r)),
              child: Text(
                'Uni Help is a community app that connects university students. '
                'Whether you are stuck on an assignment or have knowledge to share, '
                'Uni Help makes it easy to find the right person and get things done together.',
                style: TextStyle(fontSize: 13.sp, height: 1.6, color: AppColors.mediumTextColor),
              ),
            ),
            SizedBox(height: 24.h),

            // What you can do
            const _SectionTitle('What you can do'),
            SizedBox(height: 10.h),
            for (final feature in _features) _FeatureTile(data: feature),
            SizedBox(height: 16.h),

            // Footer
            Center(
              child: Text(
                '© 2026 Uni Help. All rights reserved.',
                style: TextStyle(fontSize: 11.sp, color: AppColors.mediumTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  const _FeatureData(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.data});

  final _FeatureData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(data.icon, size: 22.sp, color: AppColors.primaryColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
                ),
                SizedBox(height: 3.h),
                Text(
                  data.description,
                  style: TextStyle(fontSize: 12.sp, height: 1.4, color: AppColors.mediumTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}