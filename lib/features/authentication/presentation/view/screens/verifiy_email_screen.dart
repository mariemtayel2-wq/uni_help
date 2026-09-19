import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:uni_help/core/common/widget/app_toast.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/routing/app_route.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/features/authentication/presentation/view_model/resend_verficattion_state.dart';
import 'package:uni_help/features/authentication/presentation/view_model/resend_verification_cubit.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ResendVerificationCubit>(),
      child: _VerifyEmailView(email: email),
    );
  }
}

class _VerifyEmailView extends StatelessWidget {
  const _VerifyEmailView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResendVerificationCubit, ResendVerificationState>(
      listener: (context, state) {
        if (state is ResendVerificationSuccess) {
          AppToast.showToast(
            context: context,
            title: "Sent",
            description: "Verification email sent again — check your inbox.",
            type: ToastificationType.success,
          );
        }

        if (state is ResendVerificationError) {
          AppToast.showToast(
            context: context,
            title: "Error",
            description: state.message,
            type: ToastificationType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mark_email_unread_outlined, size: 44.sp, color: AppColors.primaryColor),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Verify your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                ),
                SizedBox(height: 12.h),
                Text(
                  "We've sent a verification link to\n$email\nOpen it, then come back and log in.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.mediumTextColor, height: 1.5),
                ),
                SizedBox(height: 32.h),
                BlocBuilder<ResendVerificationCubit, ResendVerificationState>(
                  builder: (context, state) {
                    final isLoading = state is ResendVerificationLoading;

                    return TextButton(
                      onPressed: isLoading ? null : () => context.read<ResendVerificationCubit>().resend(),
                      child: isLoading
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
                            )
                          : Text(
                              "Resend verification email",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoute.login),
                    child: Text(
                      "Back to Login",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
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