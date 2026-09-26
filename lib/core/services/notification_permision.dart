import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationPermissionService {
  NotificationPermissionService(this._plugin, this._firestore, this._auth);

  final FlutterLocalNotificationsPlugin _plugin;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<bool> requestSystemPermission() async {
    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    final granted = androidGranted ?? iosGranted ?? false;
    await _saveUserPreference(granted);
    return granted;
  }

  Future<void> updateUserPreference(bool enabled) => _saveUserPreference(enabled);

  Future<void> _saveUserPreference(bool enabled) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'notificationsEnabled': enabled,
    });
  }

  Future<bool> getUserPreference() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['notificationsEnabled'] as bool? ?? true; // true = default مفتوح
  }
}