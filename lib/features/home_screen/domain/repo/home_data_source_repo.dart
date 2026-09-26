import 'package:uni_help/core/model/current_user_dto.dart';
import 'package:uni_help/core/model/request_dto.dart';

abstract class HomeRemoteDataSource {
  Future<List<RequestModel>> getRecentRequests({String? category, int limit = 10});

  Future<CurrentUserModel> getCurrentUser();
}