class RequestEntity {
  final String? id;
  final String title;
  final String description;
  final String category;
  final String skillNeeded;
  final String? attachmentUrl;
  final DateTime? preferredTime;
  final String userId;
  final DateTime createdAt;

  const RequestEntity({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.skillNeeded,
    this.attachmentUrl, 
    this.preferredTime,
    required this.userId,
    required this.createdAt,
  });
}