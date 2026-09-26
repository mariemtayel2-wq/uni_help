import 'package:injectable/injectable.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_repo.dart';
@lazySingleton
class MarkAllNotificationsReadUseCase {
  final NotificationsRepository repo;
  MarkAllNotificationsReadUseCase(this.repo);
  Future<void> call(String uid) => repo.markAllAsRead(uid);
}