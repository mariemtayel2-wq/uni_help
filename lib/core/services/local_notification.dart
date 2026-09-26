import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalNotificationService {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );
  }

  Future<void> show({required String title, required String body}) {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'notifications_channel',
        'Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    return _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}