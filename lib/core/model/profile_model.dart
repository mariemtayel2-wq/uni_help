import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/core/entities/profile_entity.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.rating,
    required this.reviewsCount,
    this.skills = const [],
  });

  final String id;
  final String fullName;
  final String? avatarUrl;
  final double rating;
  final int reviewsCount;
  final List<String> skills;

  factory ProfileModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ProfileModel(
      id: doc.id,
      fullName: data['fullName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      skills: (data['skills'] as List<dynamic>?)?.map((s) => s.toString()).toList() ?? [],
    );
  }

  String get _initials {
    final parts = fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    return switch (parts.length) {
      0 => '?',
      1 => parts[0].substring(0, 1).toUpperCase(),
      _ => (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase(),
    };
  }

  ProfileEntity toEntity() => ProfileEntity(
        id: id,
        fullName: fullName,
        initials: _initials,
        avatarUrl: avatarUrl,
        rating: rating,
        reviewsCount: reviewsCount,
        skills: skills,
      );
}