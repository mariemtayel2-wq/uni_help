import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';

abstract class NotificationsStateCubit {}

class NotificationsStateInitial extends NotificationsStateCubit {}
class NotificationsStateLoading extends NotificationsStateCubit {}

class NotificationsStateLoaded extends NotificationsStateCubit {
  final List<NotificationEntity> notifications;
  NotificationsStateLoaded(this.notifications);
  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

class NotificationsStateError extends NotificationsStateCubit {
  final String message;
  NotificationsStateError(this.message);
}