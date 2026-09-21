import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';

abstract class ExploreState {
  const ExploreState();
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  const ExploreLoaded({
    required this.results,
    required this.selectedCategory,
    required this.searchQuery,
  });

  final List<RequestEntity> results;
  final String selectedCategory;
  final String searchQuery;

  ExploreLoaded copyWith({List<RequestEntity>? results, String? selectedCategory, String? searchQuery}) {
    return ExploreLoaded(
      results: results ?? this.results,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ExploreError extends ExploreState {
  const ExploreError(this.message);

  final String message;
}