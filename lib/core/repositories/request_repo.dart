import 'package:uni_help/core/entities/request_entity.dart';

abstract class RequestsRepository {
  Stream<List<RequestEntity>> watchMyRequests(String uid);
  Future<List<RequestEntity>> getActiveRequestsByUserId(String uid);
  Future<void> deleteRequest(RequestEntity request);
  Future<void> markAsCompleted(String requestId);
  Future<void> assignHelper({
    required String requestId,
    required String helperId,
    required String helperName,
  });
}