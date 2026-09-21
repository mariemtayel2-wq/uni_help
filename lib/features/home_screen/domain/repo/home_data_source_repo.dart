import 'package:uni_help/features/home_screen/data/model/current_user_model.dart';
import 'package:uni_help/features/home_screen/data/model/request_dto.dart';

abstract class HomeRemoteDataSource {
  Future<List<RequestModel>> getRecentRequests({String? category, int limit = 10});

  Future<CurrentUserModel> getCurrentUser();
}