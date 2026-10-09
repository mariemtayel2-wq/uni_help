import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_repo.dart';

@lazySingleton
class SendNotificationUseCase {
  final NotificationsRepository repo;
  SendNotificationUseCase(this.repo);

  Future<void> call({
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
  }) => repo.sendNotification(
        targetUid: targetUid, type: type, title: title, body: body,
        senderId: senderId, senderName: senderName,
        senderAvatarUrl: senderAvatarUrl,
        chatId: chatId,
        request: request,
        notificationId: notificationId,
      );
}