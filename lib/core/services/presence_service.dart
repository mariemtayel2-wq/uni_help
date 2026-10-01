import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PresenceService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference _statusRef(String uid) => _database.ref('status/$uid');

  Future<void> goOnline(String uid) async {
    try {
      final ref = _statusRef(uid);

      // الأول بنسجل اللي هيحصل لو الاتصال اتقطع، وبعدها نكتب إننا Online.
      await ref.onDisconnect().set({'online': false, 'lastSeen': ServerValue.timestamp});
      await ref.set({'online': true, 'lastSeen': ServerValue.timestamp});
    } catch (e) {
      // الـ presence مش حرج، فما نكسرش التطبيق لو فشل.
      debugPrint('Presence goOnline failed: $e');
    }
  }

  Future<void> goOffline(String uid) async {
    try {
      // الـ set بيستنى رد السيرفر، فلو مفيش نت منستناش أكتر من ثانيتين (عشان الـ logout ما يعلقش).
      await _statusRef(uid)
          .set({'online': false, 'lastSeen': ServerValue.timestamp})
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('Presence goOffline failed: $e');
    }
  }

  Stream<bool> watchOnline(String uid) {
    return _database
        .ref('status/$uid/online')
        .onValue
        .map((event) => event.snapshot.value == true)
        .handleError((Object e) => debugPrint('Presence watchOnline failed: $e'));
  }
}