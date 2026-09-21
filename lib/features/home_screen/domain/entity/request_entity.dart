class RequestEntity {
  const RequestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.requesterId,
    required this.requesterName,
    required this.requesterInitials,
    required this.requesterRating,
    required this.requesterRatingCount,
    this.attachments = const [],
    this.preferredTime,
    this.location,
    this.availability,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final DateTime createdAt;

  final String requesterId;
  final String requesterName;
  final String requesterInitials;
  final double requesterRating;
  final int requesterRatingCount;

  final List<String> attachments;
  final String? preferredTime;
  final String? location;
  final String? availability;
}