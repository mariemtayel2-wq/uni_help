import 'package:uni_help/features/home_screen/domain/entity/current_user_entity.dart';
import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';

abstract class HomeRepository {
  Future<List<RequestEntity>> getRecentRequests({String? category, int limit = 10});

  Future<CurrentUserEntity> getCurrentUser();
}