import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/get_profile_by_id_use_case.dart';
import 'package:uni_help/features/profile_screen/presentation/view/widgets/profile_header.dart';
import 'package:uni_help/features/rating/presentation/view/screens/rating_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<ProfileEntity> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = serviceLocator<GetProfileByIdUseCase>()(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<ProfileEntity>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Could not load this profile'));
          }
          final profile = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(profile: profile), // من غير onSettingsTap - مفيش أيقونة إعدادات هنا
                SizedBox(height: 20.h),
                if (profile.skills.isNotEmpty) ...[
                  Text('Skills', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor)),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: profile.skills
                        .map((s) => Chip(
                              label: Text(s),
                              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 24.h),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RateHelperScreen(
                          targetUserId: profile.id,
                          targetUserName: profile.fullName,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: const Text('Rate this user', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}