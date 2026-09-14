import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/routing/app_route.dart';
import 'package:uni_help/core/routing/app_router.dart';
import 'package:uni_help/core/storage_helper/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  bool isFirstTime = await LocalStorage.isFirstTime();
  print("isFirstTime = $isFirstTime");

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
          // initialRoute: isFirstTime ? AppRoute.onboarding : AppRoute.login,
          initialRoute: isFirstTime ? AppRoute.onboarding : AppRoute.appSection,
        );
      },
    );
  }
}