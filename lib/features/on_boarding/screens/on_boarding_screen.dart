
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uni_help/core/constant/app_images.dart';
import 'package:uni_help/core/routing/app_route.dart';
import 'package:uni_help/core/storage_helper/local_storage.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:uni_help/core/theme/app_rename.dart';
import 'package:uni_help/features/on_boarding/widget/button_on_boarding.dart';
import 'package:uni_help/features/on_boarding/widget/on_boarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingWidget> onboardingList = onboardingData();
  int index = 0;
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: REdgeInsets.only(left: 16, right: 16, top: 35),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60.h),
                SizedBox(
                  height: 600.h,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    itemBuilder: (context, index) => onboardingList[index],
                    itemCount: onboardingList.length,
                  ),
                ),
                SmoothPageIndicator(
                  controller: pageController, // PageController
                  count: 3,

                  effect: WormEffect(
                    dotHeight: 8.h,
                    dotWidth: 20.w,
                    dotColor: Colors.grey,
                    activeDotColor: AppColors.primaryColor,
                  ), // your preferred effect
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  onPressed: () async {
                    if (index == onboardingList.length - 1) {
                      await LocalStorage.setFirstTime(false);

                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, AppRoute.appSection);//login
                      }
                    } else {
                      pageController.animateToPage(
                        index + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  title: index == 2 ? "Get Started" : "Next",
                ),
              ],
            ),
            Positioned(
              right: 10.w,
              child: index != 2
                  ? TextButton(
                      child: Text(
                        "Skip",
                        style: AppTextStyles.semiBold14Px.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        await LocalStorage.setFirstTime(false);

                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoute.login,
                          );
                        }
                      },
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

List<OnboardingWidget> onboardingData() {
  return [
    OnboardingWidget(
      imagePath: AppImages.onboarding1,
      title: "Post Your Request",
      disc:
          "Struggling with an assignment or a concept? Post a request and get help from fellow students in minutes.",
    ),
    OnboardingWidget(
      imagePath: AppImages.onboarding2,
      title: "Help Each Other",
      disc:
          "Share your knowledge, answer questions, and earn a reputation as a top helper in your university community.",
    ),
    OnboardingWidget(
      imagePath: AppImages.onboarding3,
      title: "Grow Together",
      disc:
          "Rate your helpers, build your profile, and become part of a trusted academic community that lifts everyone up",
    ),
  ];
}
