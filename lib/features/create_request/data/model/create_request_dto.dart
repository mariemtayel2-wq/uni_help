import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/features/create_request/domain/entity/request_entity.dart';

class CreateRequestModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final String skillNeeded;
  final String? attachmentUrl;
  final DateTime? preferredTime;
  final String userId;
  final DateTime createdAt;

  const CreateRequestModel({
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

  // 1. التحويل من Entity إلى Model
  factory CreateRequestModel.fromEntity(RequestEntity entity, {String? attachmentUrl}) {
    return CreateRequestModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      skillNeeded: entity.skillNeeded,
      attachmentUrl: attachmentUrl ?? entity.attachmentUrl, 
      preferredTime: entity.preferredTime,
      userId: entity.userId,
      createdAt: entity.createdAt,
    );
  }

  // 2. التحويل من Model إلى Entity
  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      skillNeeded: skillNeeded,
      attachmentUrl: attachmentUrl,
      preferredTime: preferredTime,
      userId: userId,
      createdAt: createdAt,
    );
  }

  // 3. التحويل من Firestore Document إلى Model
  factory CreateRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CreateRequestModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      skillNeeded: data['skillNeeded'] ?? '',
      attachmentUrl: data['attachmentUrl'],
      preferredTime: data['preferredTime'] != null
          ? (data['preferredTime'] as Timestamp).toDate()
          : null,
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // 4. التحويل من Model إلى Map لإرساله لـ Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'skillNeeded': skillNeeded,
      'attachmentUrl': attachmentUrl,
      'preferredTime': preferredTime != null ? Timestamp.fromDate(preferredTime!) : null,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}