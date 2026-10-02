import 'package:uni_help/core/entities/rating_entity.dart';

abstract class RatingRepository {
  Future<void> submitRating(RatingEntity rating);
}