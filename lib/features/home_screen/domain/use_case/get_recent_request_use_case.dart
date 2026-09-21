import 'package:injectable/injectable.dart';

import 'package:uni_help/features/home_screen/domain/entity/request_entity.dart';
import 'package:uni_help/features/home_screen/domain/repo/home_repo.dart';

@lazySingleton
class GetRecentRequestsUseCase {
  const GetRecentRequestsUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<RequestEntity>> call({String? category, int limit = 10}) =>
      _repository.getRecentRequests(category: category, limit: limit);
}