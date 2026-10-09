import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/login_entity.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_repo.dart';
@lazySingleton
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;
  
  Future<void> call(LoginEntity entity) => _repository.login(entity);
}