import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';

abstract class NotificationsRemoteDataSource {
  Stream<List<NotificationEntity>> watchNotifications(String uid);
  Future<void> markAsRead(String uid, String notificationId);
  Future<void> markAllAsRead(String uid);
  Future<void> sendNotification(String targetUid, Map<String, dynamic> data);
}