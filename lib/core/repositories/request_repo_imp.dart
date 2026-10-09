import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/model/request_dto.dart';
import 'package:uni_help/core/repositories/request_repo.dart';

@LazySingleton(as: RequestsRepository)
class RequestsRepositoryImpl implements RequestsRepository {
  RequestsRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('requests');

  @override
  Stream<List<RequestEntity>> watchMyRequests(String uid) {
    try {
      // Older requests used `userId`; new requests use `requesterId`.
      // Query both fields so existing requests remain visible.
      return _col
          .where(
            Filter.or(
              Filter('requesterId', isEqualTo: uid),
              Filter('userId', isEqualTo: uid),
            ),
          )
          .snapshots()
          .map((snap) {
            final list = snap.docs
                .map((d) => RequestModel.fromMap(d.id, d.data()).toEntity())
                .toList();
            list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return list;
          });
    } catch (e) {
      throw Exception('Failed to watch your requests: $e');
    }
  }

  @override
  Future<List<RequestEntity>> getActiveRequestsByUserId(String uid) async {
    final snapshots = await Future.wait([
      _col.where('requesterId', isEqualTo: uid).get(),
      _col.where('userId', isEqualTo: uid).get(),
    ]);
    final docs = <String, Map<String, dynamic>>{};
    for (final snapshot in snapshots) {
      for (final doc in snapshot.docs) {
        docs[doc.id] = doc.data();
      }
    }

    final requests = docs.entries
        .map((entry) => RequestModel.fromMap(entry.key, entry.value).toEntity())
        .where((request) =>
            request.status != RequestStatus.completed &&
            request.status != RequestStatus.cancelled)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return requests;
  }

  @override
  Future<void> deleteRequest(RequestEntity request) async {
    if (request.status == RequestStatus.completed ||
        request.status == RequestStatus.cancelled) {
      throw Exception('Cannot delete an inactive request');
    }
    if (request.id == null) return;
    try {
      await _col.doc(request.id).delete();
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  @override
  Future<void> markAsCompleted(String requestId) async {
    try {
      await _col.doc(requestId).update({
        'status': RequestStatus.completed.name,
      });
    } catch (e) {
      throw Exception('Failed to mark request as completed: $e');
    }
  }

  @override
  Future<void> assignHelper({
    required String requestId,
    required String helperId,
    required String helperName,
  }) async {
    try {
      await _col.doc(requestId).update({
        'helperId': helperId,
        'helperName': helperName,
        'status': RequestStatus.inProgress.name,
      });
    } catch (e) {
      throw Exception('Failed to assign helper: $e');
    }
  }
}
