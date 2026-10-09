import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/rating_entity.dart';
import 'package:uni_help/core/repositories/rating_repo.dart';

@LazySingleton(as: RatingRepository)
class RatingRepositoryImpl implements RatingRepository {
  RatingRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> submitRating(RatingEntity rating) async {
    final reviewerId = _auth.currentUser?.uid;
    if (reviewerId == null || reviewerId != rating.raterId) {
      throw Exception('You must be signed in to submit a rating');
    }
    final requestId = rating.requestId;
    if (requestId == null || requestId.isEmpty) {
      throw Exception('A rating is only available after completing a request');
    }

    final userRef = _firestore.collection('users').doc(rating.targetUserId);
    final ratingRef = userRef.collection('ratings').doc(rating.raterId);
    final requestRef = _firestore.collection('requests').doc(requestId);

    try {
      await _firestore.runTransaction((txn) async {
        final existingRating = await txn.get(ratingRef);
        final requestSnap = await txn.get(requestRef);
        final userSnap = await txn.get(userRef);

        final requestData = requestSnap.data();
        if (!requestSnap.exists ||
            requestData?['requesterId'] != rating.raterId ||
            requestData?['helperId'] != rating.targetUserId ||
            requestData?['status'] != 'completed') {
          throw Exception('This request is not eligible for rating');
        }
        if (existingRating.exists) {
          throw Exception('You have already rated this request');
        }

        final currentAvg = (userSnap.data()?['rating'] as num?)?.toDouble() ?? 0;
        final currentCount = ((userSnap.data()?['ratingCount'] ??
                    userSnap.data()?['reviewsCount']) as num?)
                ?.toInt() ??
            0;

        double newAvg;
        int newCount;

        newCount = currentCount + 1;
        newAvg = ((currentAvg * currentCount) + rating.stars) / newCount;

        txn.set(ratingRef, {
          'raterId': rating.raterId,
          'raterName': rating.raterName,
          'stars': rating.stars,
          'comment': rating.comment,
          'requestId': rating.requestId,
          'createdAt': Timestamp.fromDate(rating.createdAt),
        });

        txn.update(userRef, {
          'rating': newAvg,
          'ratingCount': newCount,
          'reviewsCount': newCount,
        });
      });
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }
}