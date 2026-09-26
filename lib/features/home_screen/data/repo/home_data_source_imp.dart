import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/model/current_user_dto.dart';
import 'package:uni_help/core/model/request_dto.dart';

import 'package:uni_help/features/home_screen/domain/repo/home_data_source_repo.dart';


@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _requestsCollection = 'requests';
  static const _usersCollection = 'users';

  @override
  Future<List<RequestModel>> getRecentRequests({String? category, int limit = 10}) async {
    Query<Map<String, dynamic>> query = _firestore.collection(_requestsCollection);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    final parsedRequests = snapshot.docs.map(RequestModel.fromSnapshot).toList();
    final requests = await Future.wait(parsedRequests.map(_addRequesterData))
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));

    return requests.take(limit).toList();
  }

  Future<RequestModel> _addRequesterData(RequestModel request) async {
    if (request.requesterId.isEmpty || request.requesterName != 'Unknown') {
      return request;
    }

    final userSnapshot = await _firestore.collection(_usersCollection).doc(request.requesterId).get();
    final data = userSnapshot.data() ?? const <String, dynamic>{};
    final fullName = (data['fullName'] as String?)?.trim();

    if (fullName == null || fullName.isEmpty) {
      return request;
    }

    final parts = fullName.split(RegExp(r'\s+'));
    final initials = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return request.copyWith(
      requesterName: fullName,
      requesterInitials: initials.isEmpty ? '?' : initials,
      requesterRating: (data['rating'] as num?)?.toDouble() ?? request.requesterRating,
      requesterRatingCount: (data['ratingCount'] as num?)?.toInt() ?? request.requesterRatingCount,
    );
  }

  @override
  Future<CurrentUserModel> getCurrentUser() async {
    final uid = _firebaseAuth.currentUser?.uid;

    if (uid == null) {
      throw Exception('No account is currently signed in');
    }

    final doc = await _firestore.collection(_usersCollection).doc(uid).get();
    return CurrentUserModel.fromSnapshot(doc);
  }
}