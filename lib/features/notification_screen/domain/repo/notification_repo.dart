import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationEntity>> watchNotifications(String uid);
  Future<void> markAsRead(String uid, String notificationId);
  Future<void> markAllAsRead(String uid);

  Future<void> sendNotification({
    required String targetUid,
    required NotificationType type,
    required String title,
    required String body,
    required String senderId,
    required String senderName,
    String? senderAvatarUrl,
    String? chatId,
    RequestEntity? request,
    String? notificationId,
  });
}