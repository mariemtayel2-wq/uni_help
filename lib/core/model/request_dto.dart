import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/core/entities/request_entity.dart';

class RequestModel {
  const RequestModel({
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
    this.status = RequestStatus.pending,
    this.helperId,
    this.helperName,
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
  final RequestStatus status;
  final String? helperId;
  final String? helperName;

  // ---------- القراءة ----------

  factory RequestModel.fromFirestore(DocumentSnapshot doc) {
    return RequestModel.fromMap(
      doc.id,
      doc.data() as Map<String, dynamic>? ?? {},
    );
  }

  factory RequestModel.fromSnapshot(DocumentSnapshot doc) =>
      RequestModel.fromFirestore(doc);

  factory RequestModel.fromMap(String id, Map<String, dynamic> data) {
    final createdAtValue = data['createdAt'];
    final createdAt = createdAtValue is Timestamp
        ? createdAtValue.toDate()
        : createdAtValue is DateTime
        ? createdAtValue
        : createdAtValue is String
        ? DateTime.tryParse(createdAtValue) ?? DateTime.now()
        : DateTime.now();

    final preferredTimeValue = data['preferredTime'];
    final preferredTime = preferredTimeValue is Timestamp
        ? preferredTimeValue.toDate()
        : preferredTimeValue is DateTime
        ? preferredTimeValue
        : preferredTimeValue is String
        ? DateTime.tryParse(preferredTimeValue)
        : null;

    final ratingCountValue = data['requesterRatingCount'];
    final requesterRatingCount = ratingCountValue is num
        ? ratingCountValue.toInt()
        : int.tryParse(ratingCountValue?.toString() ?? '') ?? 0;

    final attachmentsList =
        (data['attachments'] as List<dynamic>?)
            ?.map((a) => a.toString())
            .toList() ??
        (data['attachmentUrl'] is String
            ? [data['attachmentUrl'] as String]
            : const <String>[]);

    // Support legacy documents that used snake_case or omitted status after
    // assigning a helper.
    final rawStatus = data['status']?.toString();
    final statusValue = rawStatus == 'in_progress' || rawStatus == 'In progress'
        ? RequestStatus.inProgress.name
        : rawStatus;
    final status = RequestStatus.values.firstWhere(
      (s) => s.name == statusValue,
      orElse: () =>
          (data['helperId'] ?? data['applicantId']) is String &&
              ((data['helperId'] ?? data['applicantId']) as String)
                  .trim()
                  .isNotEmpty
          ? RequestStatus.inProgress
          : RequestStatus.pending,
    );

    return RequestModel(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      skillNeeded: data['skillNeeded'] as String? ?? '',
      tags: (data['tags'] as List<dynamic>? ?? [])
          .map((t) => t.toString())
          .toList(),
      createdAt: createdAt,
      requesterId:
          data['requesterId'] as String? ?? data['userId'] as String? ?? '',
      requesterName: data['requesterName'] as String? ?? 'Unknown',
      requesterInitials: data['requesterInitials'] as String? ?? '?',
      requesterRating: (data['requesterRating'] as num?)?.toDouble() ?? 0,
      requesterRatingCount: requesterRatingCount,
      attachments: attachmentsList,
      preferredTime: preferredTime,
      location: data['location']?.toString(),
      availability: data['availability']?.toString(),
      status: status,
      helperId: data['helperId'] as String? ?? data['applicantId'] as String?,
      helperName: data['helperName'] as String?,
    );
  }

  // ---------- الكتابة ----------

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'skillNeeded': skillNeeded,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'requesterId': requesterId,
      'requesterName': requesterName,
      'requesterInitials': requesterInitials,
      'requesterRating': requesterRating,
      'requesterRatingCount': requesterRatingCount,
      'attachments': attachments,
      'preferredTime': preferredTime != null
          ? Timestamp.fromDate(preferredTime!)
          : null,
      'location': location,
      'availability': availability,
      'status': status.name,
      'helperId': helperId,
      'helperName': helperName,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  // ---------- التحويل مع الـ Entity ----------

  factory RequestModel.fromEntity(RequestEntity entity) {
    return RequestModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      skillNeeded: entity.skillNeeded,
      tags: entity.tags,
      createdAt: entity.createdAt,
      requesterId: entity.requesterId,
      requesterName: entity.requesterName,
      requesterInitials: entity.requesterInitials,
      requesterRating: entity.requesterRating,
      requesterRatingCount: entity.requesterRatingCount,
      attachments: entity.attachments,
      preferredTime: entity.preferredTime,
      location: entity.location,
      availability: entity.availability,
      status: entity.status,
      helperId: entity.helperId,
      helperName: entity.helperName,
    );
  }

  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      skillNeeded: skillNeeded,
      tags: tags,
      createdAt: createdAt,
      requesterId: requesterId,
      requesterName: requesterName,
      requesterInitials: requesterInitials,
      requesterRating: requesterRating,
      requesterRatingCount: requesterRatingCount,
      attachments: attachments,
      preferredTime: preferredTime,
      location: location,
      availability: availability,
      status: status,
      helperId: helperId,
      helperName: helperName,
    );
  }

  RequestModel copyWith({
    String? requesterName,
    String? requesterInitials,
    double? requesterRating,
    int? requesterRatingCount,
    RequestStatus? status,
    String? helperId,
    String? helperName,
  }) {
    return RequestModel(
      id: id,
      title: title,
      description: description,
      category: category,
      skillNeeded: skillNeeded,
      tags: tags,
      createdAt: createdAt,
      requesterId: requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterInitials: requesterInitials ?? this.requesterInitials,
      requesterRating: requesterRating ?? this.requesterRating,
      requesterRatingCount: requesterRatingCount ?? this.requesterRatingCount,
      attachments: attachments,
      preferredTime: preferredTime,
      location: location,
      availability: availability,
      status: status ?? this.status,
      helperId: helperId ?? this.helperId,
      helperName: helperName ?? this.helperName,
    );
  }
}
