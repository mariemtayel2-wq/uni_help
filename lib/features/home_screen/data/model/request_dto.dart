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

  factory RequestModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return RequestModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      tags: (data['tags'] as List<dynamic>? ?? []).map((t) => t.toString()).toList(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      requesterId: data['requesterId'] as String? ?? '',
      requesterName: data['requesterName'] as String? ?? 'Unknown',
      requesterInitials: data['requesterInitials'] as String? ?? '?',
      requesterRating: (data['requesterRating'] as num?)?.toDouble() ?? 0,
      requesterRatingCount: (data['requesterRatingCount'] as num?)?.toInt() ?? 0,
      attachments: (data['attachments'] as List<dynamic>? ?? []).map((a) => a.toString()).toList(),
      preferredTime: data['preferredTime'] as String?,
      location: data['location'] as String?,
      availability: data['availability'] as String?,
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