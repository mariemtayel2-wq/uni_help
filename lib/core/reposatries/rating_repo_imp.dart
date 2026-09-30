import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/rating_entity.dart';
import 'package:uni_help/core/reposatries/rating_repo.dart';

@LazySingleton(as: RatingRepository)
class RatingRepositoryImpl implements RatingRepository {
  RatingRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> submitRating(RatingEntity rating) async {
    final userRef = _firestore.collection('users').doc(rating.targetUserId);
    final ratingRef = userRef.collection('ratings').doc(rating.raterId);

    try {
      await _firestore.runTransaction((txn) async {
        final existingRating = await txn.get(ratingRef);
        final userSnap = await txn.get(userRef);

        final currentAvg = (userSnap.data()?['rating'] as num?)?.toDouble() ?? 0;
        final currentCount = (userSnap.data()?['reviewsCount'] as num?)?.toInt() ?? 0;

        double newAvg;
        int newCount;

        if (existingRating.exists) {
          final oldStars = (existingRating.data()?['stars'] as num?)?.toInt() ?? 0;
          final sumWithoutOld = (currentAvg * currentCount) - oldStars;
          newCount = currentCount;
          newAvg = newCount == 0 ? 0 : (sumWithoutOld + rating.stars) / newCount;
        } else {
          newCount = currentCount + 1;
          newAvg = ((currentAvg * currentCount) + rating.stars) / newCount;
        }

        txn.set(ratingRef, {
          'raterId': rating.raterId,
          'raterName': rating.raterName,
          'stars': rating.stars,
          'comment': rating.comment,
          'requestId': rating.requestId,
          'createdAt': Timestamp.fromDate(rating.createdAt),
        });

        txn.update(userRef, {'rating': newAvg, 'reviewsCount': newCount});
      });
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }
}