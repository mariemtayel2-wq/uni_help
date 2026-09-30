import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/my_requests/presentation/view/screen/my_request_screen.dart';
import 'package:uni_help/features/profile_screen/presentation/view/widgets/profile_shimmer.dart';
import 'package:uni_help/features/profile_screen/presentation/view/widgets/setting_tile.dart';
import 'package:uni_help/features/profile_screen/presentation/view_model/profile_cubit.dart';
import 'package:uni_help/features/profile_screen/presentation/view/widgets/profile_header.dart';
import 'package:uni_help/features/profile_screen/presentation/view/widgets/skills_editor.dart';
import 'package:uni_help/features/profile_screen/presentation/view_model/profile_state_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ProfileCubit>()..listen(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoggedOut) {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return ProfileShimmer();
                        }
            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            if (state is ProfileLoggedOut) {
              return const SizedBox.shrink();
            }
            final profile = (state as ProfileLoaded).profile;

            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h),
              children: [
                ProfileHeader(profile: profile),
                SizedBox(height: 20.h),
                SkillsEditor(
                  skills: profile.skills,
                  onAdd: (skill) => context.read<ProfileCubit>().addSkill(skill),
                  onRemove: (skill) => context.read<ProfileCubit>().removeSkill(skill),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
                  child: SettingsTile(
                    icon: Icons.list_alt_outlined,
                    title: 'My Requests',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    children: [
                      SettingsTile(icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
                      const Divider(height: 1),
                      SettingsTile(icon: Icons.info_outline, title: 'About UniHelp', onTap: () {}),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
                  child: SettingsTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    isDestructive: true,
                    onTap: () => _confirmLogout(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<ProfileCubit>().logout();
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}