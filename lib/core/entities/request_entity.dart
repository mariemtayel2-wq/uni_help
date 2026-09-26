class RequestEntity {
  const RequestEntity({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.skillNeeded,
    this.tags = const [],
    required this.createdAt,
    required this.requesterId,
    required this.requesterName,
    required this.requesterInitials,
    this.requesterRating = 0,
    this.requesterRatingCount = 0,
    this.attachments = const [],
    this.preferredTime,
    this.location,
    this.availability,
  });

  final String? id;
  final String title;
  final String description;
  final String category;
  final String skillNeeded;
  final List<String> tags;
  final DateTime createdAt;

  final String requesterId;
  final String requesterName;
  final String requesterInitials;
  final double requesterRating;
  final int requesterRatingCount;

  final List<String> attachments;
  final DateTime? preferredTime;
  final String? location;
  final String? availability;

  RequestEntity copyWith({
    String? id,
    String? requesterName,
    String? requesterInitials,
    double? requesterRating,
    int? requesterRatingCount,
  }) {
    return RequestEntity(
      id: id ?? this.id,
      title: title, description: description, category: category,
      skillNeeded: skillNeeded, tags: tags, createdAt: createdAt,
      requesterId: requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterInitials: requesterInitials ?? this.requesterInitials,
      requesterRating: requesterRating ?? this.requesterRating,
      requesterRatingCount: requesterRatingCount ?? this.requesterRatingCount,
      attachments: attachments, preferredTime: preferredTime,
      location: location, availability: availability,
    );
  }
}