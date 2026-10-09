import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/repositories/user_directory_repo.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';
import 'package:uni_help/features/notification_screen/domain/use_case/send_notification_use_case.dart';

@lazySingleton
class NotifyHelpersAboutNewRequestUseCase {
  NotifyHelpersAboutNewRequestUseCase(this._usersDirectory, this._sendNotification);

  final UsersDirectoryRepository _usersDirectory;
  final SendNotificationUseCase _sendNotification;

  Future<void> call(RequestEntity request) async {
    final matchedUids = await _usersDirectory.getUidsBySkill(
      request.skillNeeded,
      excludeUid: request.requesterId,
    );

    for (final uid in matchedUids) {
      await _sendNotification(
        targetUid: uid,
        type: NotificationType.newMatchingRequest, // ⬅️ محتاجة تضيفيها للـ enum - شوفي الملاحظة تحت
        title: 'Request for help: ${request.title}',
        body: '${request.requesterName} needs help with "${request.title}"',
        senderId: request.requesterId,
        senderName: request.requesterName,
        request: request,
      );
    }
  }
}