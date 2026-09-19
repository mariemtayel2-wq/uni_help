

import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_repo.dart';
@lazySingleton
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(RegisterEntity entity) => _repository.register(entity);
}