import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_help/features/app_section/view_model/app_section_state.dart';
import 'package:uni_help/features/explore_screen/presentation/view/screens/explore_screen.dart';
import 'package:uni_help/features/home_screen/presentation/view/screens/home_screen.dart';
import 'package:uni_help/features/notification_screen/presentation/view/screens/notifications_screen.dart';
import 'package:uni_help/features/profile_screen/presentation/view/screens/profile_screen.dart';

@injectable
class AppSectionCubit extends Cubit<AppSectionState> {
  AppSectionCubit() : super(AppSectionInitial());

  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  void changeSection(int index) {
    currentIndex = index;
    emit(AppSectionChanged(currentIndex));
  }

}