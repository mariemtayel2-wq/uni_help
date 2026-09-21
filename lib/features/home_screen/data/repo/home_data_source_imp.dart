import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import 'package:uni_help/features/home_screen/data/model/current_user_model.dart';
import 'package:uni_help/features/home_screen/data/model/request_dto.dart';
import 'package:uni_help/features/home_screen/domain/repo/home_data_source_repo.dart';


@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _requestsCollection = 'requests';
  static const _usersCollection = 'users';

  @override
  Future<List<RequestModel>> getRecentRequests({String? category, int limit = 10}) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(_requestsCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    return snapshot.docs.map(RequestModel.fromSnapshot).toList();
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