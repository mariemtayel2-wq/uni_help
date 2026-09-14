import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/constant/app_icons.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/theme/app_rename.dart';
import 'package:uni_help/features/app_section/view/widget/nav_icon.dart';
import 'package:uni_help/features/app_section/view_model/app_section_cubit.dart';
import 'package:uni_help/features/app_section/view_model/app_section_state.dart';

class AppSectionScreens extends StatefulWidget {
  const AppSectionScreens({super.key});

  @override
  State<AppSectionScreens> createState() => _AppSectionScreensState();
}

class _AppSectionScreensState extends State<AppSectionScreens> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppSectionCubit(),
      child: BlocBuilder<AppSectionCubit, AppSectionState>(
        builder: (context, state) {
          final cubit = context.read<AppSectionCubit>();

          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              extendBody: true,
              body: Stack(
                children: [
                  cubit.screens[cubit.currentIndex],
                  _FloatingNavBar(cubit: cubit),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.cubit});

  final AppSectionCubit cubit;

  static const double _barHeight = 64;
  static const double _fabSize = 56;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20.w,
      right: 20.w,
      bottom: 20.h,
      child: SizedBox(
        height: _barHeight.h + (_fabSize.h / 2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // الشريط البيضاوي (Pill) في الأسفل
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: _barHeight.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: AppColors.primaryLightColor,
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: AppIcons.homeIcon,
                        label: 'Home',
                        isSelected: cubit.currentIndex == 0,
                        onTap: () => cubit.changeSection(0),
                      ),
                      _NavItem(
                        // TODO: بدّليها بأيقونة الـ Explore بتاعتك لو مختلفة
                        icon: AppIcons.exploreIcon,
                        label: 'Explore',
                        isSelected: cubit.currentIndex == 1,
                        onTap: () => cubit.changeSection(1),
                      ),
                      // مساحة فاضية عشان الزرار العايم يقعد فوقيها
                      SizedBox(width: _fabSize.w),
                      _NavItem(
                        icon: AppIcons.rewardsIcon,
                        label: 'Alerts',
                        isSelected: cubit.currentIndex == 2,
                        onTap: () => cubit.changeSection(2),
                      ),
                      _NavItem(
                        icon: AppIcons.personalIcon,
                        label: 'Profile',
                        isSelected: cubit.currentIndex == 3,
                        onTap: () => cubit.changeSection(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // الزرار العايم (+) فوق الشريط
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: cubit.onAddTap,
                  child: Container(
                    width: _fabSize.w,
                    height: _fabSize.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 28.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            navIcon(path: icon, isSelected: isSelected),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.medium12Px.copyWith(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.mediumTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}