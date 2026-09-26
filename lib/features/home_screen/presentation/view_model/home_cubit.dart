import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/home_screen/domain/use_case/get_current_user_use_case.dart';
import 'package:uni_help/features/home_screen/domain/use_case/get_recent_request_use_case.dart';
import 'package:uni_help/features/home_screen/presentation/view_model/home_state_cubit.dart';


@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getCurrentUserUseCase, this._getRecentRequestsUseCase) : super(const HomeInitial());

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetRecentRequestsUseCase _getRecentRequestsUseCase;

  Future<void> loadHome() async {
    emit(const HomeLoading());

    try {
      final currentUser = await _getCurrentUserUseCase();
      final requests = await _getRecentRequestsUseCase(category: 'All');

      if (isClosed) return;
      emit(HomeLoaded(currentUser: currentUser, requests: requests, selectedCategory: 'All'));
    } catch (e) {
      if (isClosed) return;
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> changeCategory(String category) async {
    final current = state;
    if (current is! HomeLoaded) return;

    try {
      final requests = await _getRecentRequestsUseCase(category: category);
      if (isClosed) return;
      emit(current.copyWith(requests: requests, selectedCategory: category));
    } catch (e) {
      if (isClosed) return;
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> refresh() async {
    final current = state;
    final category = current is HomeLoaded ? current.selectedCategory : 'All';
    await changeCategory(category);
  }
}