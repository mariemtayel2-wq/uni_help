import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';

import 'package:uni_help/features/explore_screen/presentation/view_model/explore_state.dart';
import 'package:uni_help/features/home_screen/domain/use_case/get_recent_request_use_case.dart';

@injectable
class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(this._getRecentRequestsUseCase) : super(const ExploreInitial());

  final GetRecentRequestsUseCase _getRecentRequestsUseCase;

  List<RequestEntity> _categoryResults = [];

  Future<void> loadExplore({String category = 'All'}) async {
    emit(const ExploreLoading());

    try {
      final requests = await _getRecentRequestsUseCase(category: category, limit: 50);
      _categoryResults = requests;

      emit(ExploreLoaded(results: requests, selectedCategory: category, searchQuery: ''));
    } catch (e) {
      emit(ExploreError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> changeCategory(String category) => loadExplore(category: category);

  void search(String query) {
    final current = state;
    if (current is! ExploreLoaded) return;

    final q = query.trim().toLowerCase();

    final filtered = q.isEmpty
        ? _categoryResults
        : _categoryResults
              .where(
                (r) =>
                    r.title.toLowerCase().contains(q) ||
                    r.description.toLowerCase().contains(q) ||
                    r.tags.any((tag) => tag.toLowerCase().contains(q)),
              )
              .toList();

    emit(current.copyWith(results: filtered, searchQuery: query));
  }
}