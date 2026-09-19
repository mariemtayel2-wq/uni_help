import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_repo.dart';


@lazySingleton
class ResendVerificationEmailUseCase {
  const ResendVerificationEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.resendVerificationEmail();
}