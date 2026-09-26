import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/reposatries/user_directory_repo.dart';

@LazySingleton(as: UsersDirectoryRepository)
class UsersDirectoryRepositoryImpl implements UsersDirectoryRepository {
  UsersDirectoryRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<String>> getUidsBySkill(String skill, {required String excludeUid}) async {
    try {
      final snap = await _firestore
          .collection('users')
          .where('skills', arrayContains: skill)
          .get();

      return snap.docs.map((d) => d.id).where((uid) => uid != excludeUid).toList();
    } catch (e) {
      throw Exception('Failed to fetch matching helpers: $e');
    }
  }
}