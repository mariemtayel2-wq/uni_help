import 'package:uni_help/features/authentication/domain/entities/forget_entity.dart';
import 'package:uni_help/features/authentication/domain/entities/login_entity.dart';
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(LoginEntity entity);

  Future<void> register(RegisterEntity entity);

  Future<void> forgotPassword(ForgotPasswordEntity entity);

    Future<void> resendVerificationEmail();

    Future<void>signInWithGoogle() ;
}