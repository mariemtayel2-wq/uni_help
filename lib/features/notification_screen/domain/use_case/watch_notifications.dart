import 'package:injectable/injectable.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_repo.dart';

import '../entities/notification_entity.dart';
@lazySingleton
class WatchNotificationsUseCase {
  final NotificationsRepository repo;
  WatchNotificationsUseCase(this.repo);
  Stream<List<NotificationEntity>> call(String uid) => repo.watchNotifications(uid);
}
