import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/core/model/request_dto.dart';
import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';

class NotificationModel {
  static NotificationEntity fromMap(String id, Map<String, dynamic> map) {
    final requestMap = map['request'] as Map<String, dynamic>?;

    return NotificationEntity(
      id: id,
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.chatMessage,
      ),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      isRead: map['isRead'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      senderAvatarUrl: map['senderAvatarUrl'] as String?,
      chatId: map['chatId'] as String?,
      request: requestMap == null
          ? null
          : RequestModel.fromMap(
              requestMap['id'] as String? ?? '',
              requestMap,
            ).toEntity(),
    );
  }

  static Map<String, dynamic> toMap({
    required NotificationType type,
    required String title,
    required String body,
    required String senderId,
    required String senderName,
    String? senderAvatarUrl,
    String? chatId,
    RequestModel? requestModel,
  }) {
    return {
      'type': type.name,
      'title': title,
      'body': body,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'chatId': chatId,
      'request': requestModel == null
          ? null
          : {'id': requestModel.id, ...requestModel.toMap()},
    };
  }
}