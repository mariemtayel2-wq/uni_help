class RatingEntity {
  const RatingEntity({
    required this.raterId,
    required this.raterName,
    required this.targetUserId,
    required this.stars,
    this.comment,
    required this.createdAt,
    this.requestId,
  });

  final String raterId;
  final String raterName;
  final String targetUserId;
  final int stars;
  final String? comment;
  final DateTime createdAt;
  final String? requestId;
}