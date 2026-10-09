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
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';
import 'package:uni_help/features/authentication/presentation/view/screens/verifiy_email_screen.dart';
import 'package:uni_help/features/authentication/presentation/view_model/login_cubit.dart';
import 'package:uni_help/features/authentication/presentation/view_model/login_state_cubit.dart'; 
import 'package:uni_help/features/authentication/presentation/view_model/register_cubit.dart';
import 'package:uni_help/features/authentication/presentation/view_model/register_state_cubit.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _universityController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _universityController.dispose();
    _universityIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              AppToast.showToast(
                context: context,
                title: "Success",
                description: "Account created! Please verify your email to continue.",
                type: ToastificationType.success,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => VerifyEmailScreen(email: _emailController.text.trim())),
              );
            }

            if (state is RegisterError) {
              AppToast.showToast(
                context: context,
                title: "Error",
                description: state.message,
                type: ToastificationType.error,
              );
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              AppToast.showToast(
                context: context,
                title: "Success",
                description: "Signed in successfully",
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
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Full Name"),
            CustomTextField(
              filled: true,
              fillColour: AppColors.white,
              controller: _fullNameController,
              hintText: "Mariam Tayel",
              prefixIcon: Icon(Icons.person_outline, color: AppColors.mediumTextColor),
              keyboardType: TextInputType.name,
              validator: AppValidator.validateName,
            ),
            SizedBox(height: 16.h),
            _buildLabel("University"),
            CustomTextField(
              filled: true,
              fillColour: AppColors.white,
              controller: _universityController,
              hintText: "Benha University",
              prefixIcon: Icon(Icons.apartment_outlined, color: AppColors.mediumTextColor),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your university";
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildLabel("University ID"),
            CustomTextField(
              filled: true,
              fillColour: AppColors.white,
              controller: _universityIdController,
              hintText: "20231234",
              prefixIcon: Icon(Icons.badge_outlined, color: AppColors.mediumTextColor),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your university ID";
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildLabel("Email"),
            CustomTextField(
              filled: true,
              fillColour: AppColors.white,
              controller: _emailController,
              hintText: "you@uni.ie",
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.mediumTextColor),
              keyboardType: TextInputType.emailAddress,
              validator: AppValidator.validateEmail,
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
            SizedBox(height: 28.h),
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                final isLoading = state is RegisterLoading;

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

                            context.read<RegisterCubit>().register(
                              RegisterEntity(
                                fullName: _fullNameController.text.trim(),
                                university: _universityController.text.trim(),
                                universityId: _universityIdController.text.trim(),
                                email: _emailController.text.trim(),
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
                            "Create Account",
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
                  "Already have an account? ",
                  style: TextStyle(fontSize: 14.sp, color: AppColors.mediumTextColor),
                ),
                GestureDetector(
                  onTap: () => DefaultTabController.of(context).animateTo(0),
                  child: Text(
                    "Log In",
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