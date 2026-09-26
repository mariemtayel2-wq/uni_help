import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/core/entities/current_user_entity.dart';

class CurrentUserModel {
  const CurrentUserModel({
    required this.fullName,
    this.rating = 0,
    this.ratingCount = 0,
    this.avatarUrl,
  });

  final String fullName;
  final double rating;
  final int ratingCount;
  final String? avatarUrl;

  factory CurrentUserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CurrentUserModel(
      fullName: data['fullName'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      avatarUrl: data['avatarUrl'] as String?,
    );
  }

  CurrentUserEntity toEntity() => CurrentUserEntity.fromFullName(
        fullName,
        rating: rating,
        ratingCount: ratingCount,
        avatarUrl: avatarUrl,
      );
}