import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _supportEmail = 'mariemtayel2@gmail.com';

  static const _steps = [
    _StepData('Create your account', 'Sign up with your university email or ID, then verify your email.'),
    _StepData('Post or find a request', 'Ask for help with a request, or browse requests from other students.'),
    _StepData('Offer help and chat', 'Tap "Offer Help" to start a chat and agree on the details.'),
    _StepData('Rate your experience', 'Once you are done, leave a rating to help the community.'),
  ];

  static const _faqs = [
    _FaqData(
      'How do I log in with my university ID?',
      'On the login screen, enter your university ID instead of your email, then type your password. Make sure your email is verified first.',
    ),
    _FaqData(
      'I forgot my password. What should I do?',
      'Tap "Forgot password" on the login screen and enter your email. We will send you a link to reset it.',
    ),
    _FaqData(
      'Where can I find my conversations?',
      'Tap the chat icon on the home screen to open your messages. You will see every conversation with its latest message.',
    ),
    _FaqData(
      'How do ratings work?',
      'After getting help, you can rate the other student. Ratings appear on their profile and help others know who to trust.',
    ),
  ];

  Future<void> _contactSupport(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse('mailto:$_supportEmail?subject=Uni%20Help%20Support');

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) throw Exception('Could not launch email app');
    } catch (e) {
      debugPrint('Error launching email: $e');
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open your email app. Write to $_supportEmail')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.largeTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            // Intro
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_rounded, size: 26.sp, color: AppColors.primaryColor),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Uni Help connects university students who need a hand with students who can help. '
                      'Post a request, get offers, chat, and get things done.',
                      style: TextStyle(fontSize: 13.sp, height: 1.5, color: AppColors.largeTextColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // How it works
            const _SectionTitle('How it works'),
            SizedBox(height: 10.h),
            for (var i = 0; i < _steps.length; i++)
              _StepTile(number: i + 1, data: _steps[i]),
            SizedBox(height: 12.h),

            // FAQ
            const _SectionTitle('Frequently asked questions'),
            SizedBox(height: 10.h),
            for (final faq in _faqs) _FaqTile(data: faq),
            SizedBox(height: 12.h),

            // Contact
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                children: [
                  Text(
                    'Need help? Contact us',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _supportEmail,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.mediumTextColor),
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                        elevation: 0,
                      ),
                      onPressed: () => _contactSupport(context),
                      icon: Icon(Icons.mail_outline_rounded, size: 18.sp, color: Colors.white),
                      label: Text(
                        'Email support',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepData {
  const _StepData(this.title, this.description);

  final String title;
  final String description;
}

class _FaqData {
  const _FaqData(this.question, this.answer);

  final String question;
  final String answer;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.largeTextColor),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.data});

  final int number;
  final _StepData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              '$number',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
                ),
                SizedBox(height: 3.h),
                Text(
                  data.description,
                  style: TextStyle(fontSize: 12.sp, height: 1.4, color: AppColors.mediumTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.data});

  final _FaqData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14.r)),
      clipBehavior: Clip.antiAlias,
      // بنشيل الخطوط الفاصلة الافتراضية بتاعت ExpansionTile.
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 14.w),
          childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: AppColors.primaryColor,
          collapsedIconColor: AppColors.mediumTextColor,
          title: Text(
            data.question,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.largeTextColor),
          ),
          children: [
            Text(
              data.answer,
              style: TextStyle(fontSize: 12.sp, height: 1.5, color: AppColors.mediumTextColor),
            ),
          ],
        ),
      ),
    );
  }
}