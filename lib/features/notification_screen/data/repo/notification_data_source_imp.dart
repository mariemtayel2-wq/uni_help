import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/notification_screen/data/model/notification_dto.dart';
import 'package:uni_help/features/notification_screen/domain/entities/notification_entity.dart';
import 'package:uni_help/features/notification_screen/domain/repo/notification_data_source.dart';

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection('users').doc(uid).collection('notifications');

  @override
  Stream<List<NotificationEntity>> watchNotifications(String uid) {
    try {
      return _col(uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snap) {
            try {
              return snap.docs
                  .map((d) => NotificationModel.fromMap(d.id, d.data()))
                  .toList();
            } catch (e) {
              throw Exception('Failed to parse notifications: $e');
            }
          });
    } catch (e) {
      throw Exception('Failed to watch notifications: $e');
    }
  }

  @override
  Future<void> markAsRead(String uid, String id) async {
    try {
      await _col(uid).doc(id).update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllAsRead(String uid) async {
    try {
      final unread = await _col(uid).where('isRead', isEqualTo: false).get();
      if (unread.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in unread.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<void> sendNotification(
    String targetUid,
    Map<String, dynamic> data, {
    String? notificationId,
  }) async {
    try {
      final ref = notificationId == null
          ? _col(targetUid).doc()
          : _col(targetUid).doc(notificationId);
      await ref.set(data);
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }
}
