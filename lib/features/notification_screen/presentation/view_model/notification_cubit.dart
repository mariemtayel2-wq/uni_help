import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/notification_screen/presentation/view_model/notification_state_cubit.dart';

import '../../../../core/services/local_notification.dart';
import '../../../../core/services/notification_permision.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_case/make_all_as_read_use_case.dart';
import '../../domain/use_case/mark_as_read_use_case.dart';
import '../../domain/use_case/watch_notifications.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsStateCubit> {
  NotificationsCubit({
    required this.watchNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
    required this.localNotificationService,
    required this.permissionService,
  }) : super(NotificationsStateInitial());

  final WatchNotificationsUseCase watchNotificationsUseCase;
  final MarkNotificationReadUseCase markAsReadUseCase;
  final MarkAllNotificationsReadUseCase markAllAsReadUseCase;
  final LocalNotificationService localNotificationService;
  final NotificationPermissionService permissionService;

  StreamSubscription<List<NotificationEntity>>? _sub;
  List<String> _knownIds = [];
  bool _isFirstEmit = true;

  void listen(String uid) {
    emit(NotificationsStateLoading());
    _sub?.cancel();
    _isFirstEmit = true;

    _sub = watchNotificationsUseCase(uid).listen(
      (notifications) async {
        await _handleNewNotifications(notifications);
        emit(NotificationsStateLoaded(notifications));
      },
      onError: (e) => emit(NotificationsStateError(e.toString())),
    );
  }

  Future<void> _handleNewNotifications(List<NotificationEntity> notifications) async {

    if (_isFirstEmit) {
      _knownIds = notifications.map((n) => n.id).toList();
      _isFirstEmit = false;
      return;
    }

    final newOnes = notifications.where((n) => !_knownIds.contains(n.id)).toList();
    _knownIds = notifications.map((n) => n.id).toList();

    if (newOnes.isEmpty) return;

    final userWantsNotifications = await permissionService.getUserPreference();
    if (!userWantsNotifications) return;

    for (final n in newOnes) {
      await localNotificationService.show(title: n.title, body: n.body);
    }
  }

  Future<void> onNotificationTapped(String uid, NotificationEntity n) async {
    if (!n.isRead) await markAsReadUseCase(uid, n.id);
  }

  Future<void> markAllAsRead(String uid) => markAllAsReadUseCase(uid);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}