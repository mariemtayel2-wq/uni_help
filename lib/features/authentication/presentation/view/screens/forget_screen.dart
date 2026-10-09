import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:uni_help/core/common/widget/app_toast.dart';
import 'package:uni_help/core/common/widget/custum_text_form_field.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/routing/app_route.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/validators/app_vaildator.dart';
import 'package:uni_help/features/authentication/domain/entities/forget_entity.dart';
import 'package:uni_help/features/authentication/presentation/view_model/forget_cubit.dart';
import 'package:uni_help/features/authentication/presentation/view_model/forget_state_cubit.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ForgotPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          AppToast.showToast(
            context: context,
            title: "Success",
            description: state.message,
            type: ToastificationType.success,
          );
          Navigator.pushReplacementNamed(context, AppRoute.login);
        }

        if (state is ForgotPasswordError) {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 70.h, bottom: 35.h, left: 20.w, right: 20.w),
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
                      child: Icon(Icons.lock_reset_rounded, size: 32.sp, color: Colors.white),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Forgot Password?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Enter your email and we'll send you a link to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          "Email address",
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ),
                      CustomTextField(
                        filled: true,
                        fillColour: AppColors.white,
                        controller: _emailController,
                        hintText: "you@uni.ie",
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.mediumTextColor),
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.validateEmail,
                      ),
                      SizedBox(height: 30.h),
                      BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                        builder: (context, state) {
                          final isLoading = state is ForgotPasswordLoading;

                          return SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                                elevation: 0,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (!_formKey.currentState!.validate()) return;

                                      context.read<ForgotPasswordCubit>().forgotPassword(
                                        ForgotPasswordEntity(email: _emailController.text.trim()),
                                      );
                                    },
                              child: isLoading
                                  ? SizedBox(
                                      width: 22.w,
                                      height: 22.h,
                                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : Text(
                                      "Send Reset Link",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 25.h),
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, AppRoute.login),
                          icon: Icon(Icons.arrow_back, size: 18.sp, color: AppColors.primaryColor),
                          label: Text(
                            "Back to Login",
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}