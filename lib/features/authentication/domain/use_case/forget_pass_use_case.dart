

import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/forget_entity.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_repo.dart';
@lazySingleton
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(ForgotPasswordEntity entity) => _repository.forgotPassword(entity);
}