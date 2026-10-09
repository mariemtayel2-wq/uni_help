// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_help/core/constant/request_category.dart';

import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/services/notification_permision.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/app_section/view_model/app_section_cubit.dart';
import 'package:uni_help/features/app_section/view_model/app_section_state.dart';
import 'package:uni_help/features/chat_screen/presentation/view/screen/chat_list_screen.dart';
import 'package:uni_help/features/home_screen/presentation/view/screens/request_card.dart';
import 'package:uni_help/features/home_screen/presentation/view/utils/home_shimmer.dart';
import 'package:uni_help/features/home_screen/presentation/view_model/home_cubit.dart';
import 'package:uni_help/features/home_screen/presentation/view_model/home_state_cubit.dart';
import 'package:uni_help/features/request_detail_screen/request_details_screen.dart';
import 'package:uni_help/features/profile_screen/presentation/view/screens/user_profile_screen.dart';

const _categories = requestCategories;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<HomeCubit>()..loadHome(),
      child: const _HomeView(),
    );
  }

    @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }
}
Future<void> _checkNotificationPermission() async {
  final prefs = await SharedPreferences.getInstance();

  final alreadyAsked =
      prefs.getBool('asked_notification_permission') ?? false;

  if (!alreadyAsked) {
    await _askForNotificationPermission();
    await prefs.setBool('asked_notification_permission', true);
  }
}
Future<void> _askForNotificationPermission() async {
  final granted = await serviceLocator<NotificationPermissionService>().requestSystemPermission();}
class _HomeView extends StatelessWidget {
  const _HomeView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<AppSectionCubit, AppSectionState>(
        listener: (context, state) {
          if (state is AppSectionChanged && state.currentIndex == 0) {
            context.read<HomeCubit>().refresh();
          }
        },
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const HomeScreenShimmer();
            }

            if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 40.sp, color: AppColors.mediumTextColor),
                      SizedBox(height: 12.h),
                      Text(state.message, textAlign: TextAlign.center),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => context.read<HomeCubit>().loadHome(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final loaded = state as HomeLoaded;

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 120.h), // مساحة تحت عشان الـ floating nav bar
                children: [
                  _Header(name: loaded.currentUser.fullName, initials: loaded.currentUser.initials),
                  SizedBox(height: 20.h),
                  const _SearchBar(),
                  SizedBox(height: 16.h),
                  _CategoryChips(selected: loaded.selectedCategory),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Requests',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                      ),
                      InkWell(
                        onTap: () => context.read<AppSectionCubit>().changeSection(1), // 1 = Explore
                        child: Text(
                          'See all ›',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  if (loaded.requests.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Text(
                          'No requests yet in this category',
                          style: TextStyle(color: AppColors.mediumTextColor),
                        ),
                      ),
                    )
                  else
                    ...loaded.requests.map(
                      (r) => RequestCard(
                        request: r,
                        onRequesterTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserProfileScreen(uid: r.requesterId),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RequestDetailsScreen(request: r)),
                        ),
                      ),
                    ),
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.initials});

  final String name;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $name 👋',
              style: TextStyle(fontSize: 13.sp, color: AppColors.mediumTextColor),
            ),
            SizedBox(height: 2.h),
            Text(
              "Let's make a difference today",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
            ),
          
          ],
        ),
        IconButton(
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatsListScreen()));
  },
  icon: Transform.flip(
    flipX: true,
    child: Icon(Icons.chat, color: AppColors.mediumTextColor),
  ),
),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () => context.read<AppSectionCubit>().changeSection(1), // 1 = Explore
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.mediumTextColor, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                'Search for help...',
                style: TextStyle(color: AppColors.mediumTextColor, fontSize: 14.sp),
              ),
            ),
            Icon(Icons.tune, color: AppColors.primaryColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == selected;

          return ChoiceChip(
            showCheckmark: false,
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => context.read<HomeCubit>().changeCategory(category),
            backgroundColor: AppColors.white,
            selectedColor: AppColors.primaryColor,
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.mediumTextColor,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r), side: BorderSide.none),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
          );
        },
      ),
    );
  }
}
