import 'package:uni_help/core/entities/current_user_entity.dart';
import 'package:uni_help/core/entities/request_entity.dart';

abstract class HomeRepository {
  Future<List<RequestEntity>> getRecentRequests({String? category, int limit = 10});
  Future<CurrentUserEntity> getCurrentUser();
}