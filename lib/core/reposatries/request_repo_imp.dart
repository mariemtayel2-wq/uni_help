import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/model/request_dto.dart';
import 'package:uni_help/core/reposatries/request_repo.dart';

@LazySingleton(as: RequestsRepository)
class RequestsRepositoryImpl implements RequestsRepository {
  RequestsRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col => _firestore.collection('requests');

  @override
  Stream<List<RequestEntity>> watchMyRequests(String uid) {
    try {
      return _col.where('requesterId', isEqualTo: uid).snapshots().map((snap) {
        final list = snap.docs.map((d) => RequestModel.fromMap(d.id, d.data()).toEntity()).toList();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      });
    } catch (e) {
      throw Exception('Failed to watch your requests: $e');
    }
  }

  @override
  Future<void> deleteRequest(RequestEntity request) async {
    if (request.status != RequestStatus.pending) {
      throw Exception('Cannot delete a request that is not pending');
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
      await _col.doc(requestId).update({'status': RequestStatus.completed.name});
    } catch (e) {
      throw Exception('Failed to mark request as completed: $e');
    }
  }
}