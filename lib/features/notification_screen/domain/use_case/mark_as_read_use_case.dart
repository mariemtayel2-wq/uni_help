
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_repo.dart';

@lazySingleton
class MarkNotificationReadUseCase {
  final NotificationsRepository repo;
  MarkNotificationReadUseCase(this.repo);
  Future<void> call(String uid, String id) => repo.markAsRead(uid, id);
}