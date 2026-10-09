import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_help/core/di/service_locator.dart';
import 'package:uni_help/core/routing/app_router.dart';
import 'package:uni_help/core/services/local_notification.dart';
import 'package:uni_help/core/services/presence_service.dart';
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

  final isFirstTime = await LocalStorage.isFirstTime();

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.isFirstTime,
  });

  final bool isFirstTime;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final PresenceService _presenceService =
      serviceLocator<PresenceService>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _handleAuthState();
  }

  void _handleAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _presenceService.goOnline(user.uid);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (state == AppLifecycleState.resumed) {
      _presenceService.goOnline(user.uid);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _presenceService.goOffline(user.uid);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _presenceService.goOffline(user.uid);
    }

    super.dispose();
  }

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
          home: widget.isFirstTime
              ? const OnboardingScreen()
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      return AppSectionScreens();
                    }

                    return const AuthScreen();
                  },
                ),
        );
      },
    );
  }
}