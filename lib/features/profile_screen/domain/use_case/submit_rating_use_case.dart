import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/rating_entity.dart';
import 'package:uni_help/core/reposatries/rating_repo.dart';

@lazySingleton
class SubmitRatingUseCase {
  const SubmitRatingUseCase(this._repo);
  final RatingRepository _repo;
  Future<void> call(RatingEntity rating) => _repo.submitRating(rating);
}