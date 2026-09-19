import 'package:flutter/material.dart';
import 'package:uni_help/core/routing/app_route.dart';
import 'package:uni_help/features/app_section/view/screens/bottom_nav_bar.dart';
import 'package:uni_help/features/authentication/presentation/view/screens/auth_screen.dart';
import 'package:uni_help/features/authentication/presentation/view/screens/forget_screen.dart';
import 'package:uni_help/features/on_boarding/screens/on_boarding_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.appSection:
        return MaterialPageRoute(
          builder: (_) => const AppSectionScreens(),
        );
        case AppRoute.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
        case AppRoute.login:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
        case AppRoute.register:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
        case AppRoute.forgetScreen:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
       
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('No route defined for this path'),
            ),
          ),
        );
    }}}