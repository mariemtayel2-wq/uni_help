import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/forget_entity.dart';
import 'package:uni_help/features/authentication/domain/entities/login_entity.dart';
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_data_source.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_repo.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;
  @override
  Future<void> login(LoginEntity entity) => _remoteDataSource.login(entity);
  @override
  Future<void> register(RegisterEntity entity) => _remoteDataSource.register(entity);
  @override
  Future<void> forgotPassword(ForgotPasswordEntity entity) =>
      _remoteDataSource.forgotPassword(entity);
  @override
  Future<void> resendVerificationEmail() => _remoteDataSource.resendVerificationEmail();
  @override
  Future<void> signInWithGoogle() => _remoteDataSource.signInWithGoogle();
}