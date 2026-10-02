import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/repositories/request_repo.dart';

@lazySingleton
class DeleteRequestUseCase {
  const DeleteRequestUseCase(this._repo);
  final RequestsRepository _repo;
  Future<void> call(RequestEntity request) => _repo.deleteRequest(request);
}