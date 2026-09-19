import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.fullName,
    required this.university,
    required this.email,
    this.universityId,
    this.createdAt,
  });

  final String uid;
  final String fullName;
  final String university;
  final String email;
  final String? universityId;
  final DateTime? createdAt;

  factory UserModel.fromEntity(RegisterEntity entity, {required String uid}) {
    return UserModel(
      uid: uid,
      fullName: entity.fullName,
      university: entity.university,
      email: entity.email.trim(),
      universityId: entity.universityId,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      university: data['university'] as String? ?? '',
      email: data['email'] as String? ?? '',
      universityId: data['universityId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'university': university,
      'email': email,
      if (universityId != null) 'universityId': universityId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}