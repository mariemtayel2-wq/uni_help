import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/model/request_dto.dart';
import 'package:uni_help/features/notification_screen/data/model/notification_dto.dart';
import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_data_source.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_repo.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote; // ⬅️ Interface دلوقتي مش الـ Impl مباشرة

  @override
  Stream<List<NotificationEntity>> watchNotifications(String uid) =>
      _remote.watchNotifications(uid);

  @override
  Future<void> markAsRead(String uid, String id) => _remote.markAsRead(uid, id);

  @override
  Future<void> markAllAsRead(String uid) => _remote.markAllAsRead(uid);

  @override
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
  }) {
    final data = NotificationModel.toMap(
      type: type,
      title: title,
      body: body,
      senderId: senderId,
      senderName: senderName,
      senderAvatarUrl: senderAvatarUrl,
      chatId: chatId,
      requestModel: request == null ? null : RequestModel.fromEntity(request),
    );
    return _remote.sendNotification(targetUid, data);
  }
}