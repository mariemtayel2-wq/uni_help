import 'package:uni_help/core/entities/request_entity.dart';

abstract class RequestsRepository {
  Stream<List<RequestEntity>> watchMyRequests(String uid);
  Future<void> deleteRequest(RequestEntity request);
  Future<void> markAsCompleted(String requestId);
}