import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';

class RequestModel {
  const RequestModel({
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

  RequestModel copyWith({
    String? requesterName,
    String? requesterInitials,
    double? requesterRating,
    int? requesterRatingCount,
  }) {
    return RequestModel(
      id: id,
      title: title,
      description: description,
      category: category,
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
    );
  }

  factory RequestModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final createdAtValue = data['createdAt'];
    final createdAt = createdAtValue is Timestamp
        ? createdAtValue.toDate()
        : createdAtValue is DateTime
            ? createdAtValue
            : createdAtValue is String
                ? DateTime.tryParse(createdAtValue) ?? DateTime.now()
                : DateTime.now();
          final attachmentValue = data['attachmentUrl'];
          final attachmentUrl = attachmentValue is String ? attachmentValue : null;
          final preferredTimeValue = data['preferredTime'];
          final preferredTime = preferredTimeValue is Timestamp
            ? preferredTimeValue.toDate().toIso8601String()
            : preferredTimeValue is DateTime
              ? preferredTimeValue.toIso8601String()
              : preferredTimeValue is String
                ? preferredTimeValue
                : null;
          final ratingCountValue = data['requesterRatingCount'];
          final requesterRatingCount = ratingCountValue is num
              ? ratingCountValue.toInt()
              : int.tryParse(ratingCountValue?.toString() ?? '') ?? 0;

    return RequestModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      tags: (data['tags'] as List<dynamic>? ?? []).map((t) => t.toString()).toList(),
      createdAt: createdAt,
      requesterId: data['requesterId'] as String? ?? data['userId'] as String? ?? '',
      requesterName: data['requesterName'] as String? ?? 'Unknown',
      requesterInitials: data['requesterInitials'] as String? ?? '?',
      requesterRating: (data['requesterRating'] as num?)?.toDouble() ?? 0,
      requesterRatingCount: requesterRatingCount,
        attachments: (data['attachments'] as List<dynamic>?)?.map((a) => a.toString()).toList() ??
          (attachmentUrl == null ? const [] : [attachmentUrl]),
      preferredTime: preferredTime,
      location: data['location']?.toString(),
      availability: data['availability']?.toString(),
    );
  }

  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      title: title,
      description: description,
      category: category,
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
    );
  }
}