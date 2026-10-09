import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:uni_help/core/common/widget/app_toast.dart';
import 'package:uni_help/core/common/widget/custum_text_form_field.dart';
import 'package:uni_help/core/routing/app_route.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/validators/app_vaildator.dart';
import 'package:uni_help/features/authentication/domain/entities/login_entity.dart';
import 'package:uni_help/features/authentication/presentation/view_model/login_cubit.dart';
import 'package:uni_help/features/authentication/presentation/view_model/login_state_cubit.dart';



class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailOrIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppToast.showToast(
            context: context,
            title: "Success",
            description: "Login successful",
            type: ToastificationType.success,
          );
          Navigator.pushReplacementNamed(context, AppRoute.appSection);
        }

        if (state is LoginError) {
          AppToast.showToast(
            context: context,
            title: "Error",
            description: state.message,
            type: ToastificationType.error,
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Email or university ID"),
            CustomTextField(
              filled: true,
              fillColour: AppColors.white,
              controller: _emailOrIdController,
              hintText: "you@uni.ie",
              prefixIcon: Icon(Icons.person_outline, color: AppColors.mediumTextColor),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your email or university ID";
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildLabel("Password"),
            CustomTextField(
              filled: true,
              fillColour: AppColors.white,
              controller: _passwordController,
              hintText: "••••••••",
              obscureText: _obscurePassword,
              prefixIcon: Icon(Icons.lock_outline, color: AppColors.mediumTextColor),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: AppValidator.validatePassword,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoute.forgetScreen),
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final isLoading = state is LoginLoading;

                return SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!_formKey.currentState!.validate()) return;

                            context.read<LoginCubit>().login(
                              LoginEntity(
                                emailOrUniversityId: _emailOrIdController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                          },
                    child: isLoading
                        ? SizedBox(
                            width: 22.w,
                            height: 22.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Log In",
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
            SizedBox(height: 24.h),
            _buildDivider(),
            SizedBox(height: 20.h),
             BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final isGoogleLoading = state is LoginLoading;

                return _SocialButton(
                  icon: isGoogleLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
                        )
                      : const FaIcon(FontAwesomeIcons.google, size: 18, color: Colors.redAccent),
                  label: "Continue with Google",
                  onTap: isGoogleLoading ? () {} : () => context.read<LoginCubit>().signInWithGoogle(),
                );
              },
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 14.sp, color: AppColors.mediumTextColor),
                ),
                GestureDetector(
                  onTap: () => DefaultTabController.of(context).animateTo(1),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
    ),
  );

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text("or", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        ),
        const Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label, required this.onTap});

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 10.w),
            Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}