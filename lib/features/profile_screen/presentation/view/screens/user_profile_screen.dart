import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/repositories/request_repo.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/get_profile_by_id_use_case.dart';
import 'package:uni_help/features/profile_screen/presentation/view/widgets/profile_header.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<List<RequestEntity>> _futureRequests;

  @override
  void initState() {
    super.initState();
    _futureRequests =
        serviceLocator<RequestsRepository>().getActiveRequestsByUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<ProfileEntity>(
        stream: serviceLocator<GetProfileByIdUseCase>().watch(widget.uid),
        builder: (context, profileSnapshot) {
          if (profileSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileSnapshot.hasError || !profileSnapshot.hasData) {
            return const Center(child: Text('Could not load this profile'));
          }
          final profile = profileSnapshot.data!;

          return FutureBuilder<List<RequestEntity>>(
            future: _futureRequests,
            builder: (context, requestSnapshot) {
              if (requestSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (requestSnapshot.hasError) {
                return const Center(child: Text('Could not load this profile'));
              }

              final requests = requestSnapshot.data ?? const <RequestEntity>[];
              return ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  ProfileHeader(profile: profile),
                  SizedBox(height: 20.h),
                  Text('Skills',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.largeTextColor)),
                  SizedBox(height: 8.h),
                  if (profile.skills.isEmpty)
                    Text('No skills added yet',
                        style: TextStyle(color: AppColors.mediumTextColor))
                  else
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: profile.skills
                          .map((skill) => Chip(
                                label: Text(skill),
                                backgroundColor:
                                    AppColors.primaryColor.withOpacity(0.1),
                              ))
                          .toList(),
                    ),
                  SizedBox(height: 24.h),
                  Text('Active Requests',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.largeTextColor)),
                  SizedBox(height: 8.h),
                  if (requests.isEmpty)
                    Text('No active requests',
                        style: TextStyle(color: AppColors.mediumTextColor))
                  else
                    ...requests.map(
                      (request) => Card(
                        child: ListTile(
                          title: Text(request.title),
                          subtitle: Text(request.category),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}