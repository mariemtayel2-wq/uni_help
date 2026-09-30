import 'package:injectable/injectable.dart';
import 'package:uni_help/core/reposatries/request_repo.dart';

@lazySingleton
class MarkRequestCompletedUseCase {
  const MarkRequestCompletedUseCase(this._repo);
  final RequestsRepository _repo;
  Future<void> call(String requestId) => _repo.markAsCompleted(requestId);
}