import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/routing/app_router.dart';
import 'package:uni_help/core/services/local_notification.dart';
import 'package:uni_help/core/storage_helper/local_storage.dart';
import 'package:uni_help/features/app_section/view/screens/bottom_nav_bar.dart';
import 'package:uni_help/features/authentication/presentation/view/screens/auth_screen.dart';
import 'package:uni_help/features/on_boarding/screens/on_boarding_screen.dart';
import 'package:uni_help/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
    await serviceLocator<LocalNotificationService>().init();
  bool isFirstTime = await LocalStorage.isFirstTime();

  runApp(MyApp(isFirstTime: isFirstTime));
}
class MyApp extends StatelessWidget {

  const MyApp({super.key, required this.isFirstTime});
  final bool isFirstTime;

  @override

  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          home: isFirstTime
              ? const OnboardingScreen() // أو توجيهه للـ onboarding
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return  AppSectionScreens(); }
                    return const AuthScreen(); 
                  },
                ),
        );
      },
    );
  }}