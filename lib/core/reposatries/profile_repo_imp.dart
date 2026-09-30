import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/profile_entity.dart';
import 'package:uni_help/core/model/profile_model.dart';
import 'package:uni_help/core/reposatries/profile_repo.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> get _doc {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('No authenticated user');
    return _firestore.collection('users').doc(uid);
  }

  @override
  Future<ProfileEntity> getProfile() async {
    final snap = await _doc.get();
    return ProfileModel.fromSnapshot(snap).toEntity();
  }

  @override
  Stream<ProfileEntity> watchProfile() {
    return _doc.snapshots().map((snap) => ProfileModel.fromSnapshot(snap).toEntity());
  }

  @override
  Future<ProfileEntity> getProfileById(String uid) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    return ProfileModel.fromSnapshot(snap).toEntity();
  }

  @override
  Future<void> addSkill(String skill) async {
    final trimmed = skill.trim();
    if (trimmed.isEmpty) return;
    await _doc.update({'skills': FieldValue.arrayUnion([trimmed])});
  }

  @override
  Future<void> removeSkill(String skill) async {
    await _doc.update({'skills': FieldValue.arrayRemove([skill])});
  }
}