import 'package:uni_help/core/entities/current_user_entity.dart';

class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.initials,
    this.avatarUrl,
    required this.rating,
    required this.reviewsCount,
    this.skills = const [],
  });

  final String id;
  final String fullName;
  final String initials;
  final String? avatarUrl;
  final double rating;
  final int reviewsCount;
  final List<String> skills;

  CurrentUserEntity toCurrentUser() => CurrentUserEntity(
        fullName: fullName,
        initials: initials,
        rating: rating,
        ratingCount: reviewsCount,
        avatarUrl: avatarUrl,
      );
}