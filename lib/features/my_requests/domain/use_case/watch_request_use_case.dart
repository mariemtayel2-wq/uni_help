import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/reposatries/request_repo.dart';

@lazySingleton
class WatchMyRequestsUseCase {
  const WatchMyRequestsUseCase(this._repo);
  final RequestsRepository _repo;
  Stream<List<RequestEntity>> call(String uid) => _repo.watchMyRequests(uid);
}