import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';


class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    this.chatId,
    this.request, // <-- نفس RequestEntity بتاعك، من غير أي تكرار
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;

  final String? chatId;
  final RequestEntity? request;

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id, type: type, title: title, body: body,
        isRead: isRead ?? this.isRead, createdAt: createdAt,
        senderId: senderId, senderName: senderName,
        senderAvatarUrl: senderAvatarUrl, chatId: chatId, request: request,
      );
}