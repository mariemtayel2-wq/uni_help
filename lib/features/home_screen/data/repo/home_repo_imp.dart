import 'package:injectable/injectable.dart';

import 'package:uni_help/features/home_screen/domain/entity/current_user_entity.dart';
import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';
import 'package:uni_help/features/home_screen/domain/repo/home_data_source_repo.dart';
import 'package:uni_help/features/home_screen/domain/repo/home_repo.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<RequestEntity>> getRecentRequests({String? category, int limit = 10}) async {
    final models = await _remoteDataSource.getRecentRequests(category: category, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CurrentUserEntity> getCurrentUser() async {
    final model = await _remoteDataSource.getCurrentUser();
    return model.toEntity();
  }
}