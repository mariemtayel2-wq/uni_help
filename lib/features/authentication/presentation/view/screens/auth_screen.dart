import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/authentication/presentation/view/screens/login_form.dart';
import 'package:uni_help/features/authentication/presentation/view/screens/register_form.dart';
import 'package:uni_help/features/authentication/presentation/view_model/login_cubit.dart';
import 'package:uni_help/features/authentication/presentation/view_model/register_cubit.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<LoginCubit>()),
          BlocProvider(create: (_) => serviceLocator<RegisterCubit>()),
        ],
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const _AuthHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Builder(
                    builder: (context) {
                      final tabController = DefaultTabController.of(context);
                      return AnimatedBuilder(
                        animation: tabController,
                        builder: (context, _) {
                          return tabController.index == 0
                              ? const LoginForm()
                              : const SignUpForm();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(color: AppColors.blackShadow, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, color: Colors.white, size: 32.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "Welcome back",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 6.h),
          Text(
            "Sign in to continue",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.white70),
          ),
          SizedBox(height: 20.h),
          TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Login"),
              Tab(text: "Sign Up"),
            ],
          ),
        ],
      ),
    );
  }
}