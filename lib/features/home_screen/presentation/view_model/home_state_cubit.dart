import 'package:uni_help/features/home_screen/domain/entity/current_user_entity.dart';
import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.currentUser,
    required this.requests,
    required this.selectedCategory,
  });

  final CurrentUserEntity currentUser;
  final List<RequestEntity> requests;
  final String selectedCategory;

  HomeLoaded copyWith({List<RequestEntity>? requests, String? selectedCategory}) {
    return HomeLoaded(
      currentUser: currentUser,
      requests: requests ?? this.requests,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}