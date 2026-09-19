import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/login_entity.dart';
import 'package:uni_help/features/authentication/domain/use_case/google_in_use_case.dart';
import 'package:uni_help/features/authentication/domain/use_case/log_in_use_case.dart';
import 'package:uni_help/features/authentication/presentation/view_model/login_state_cubit.dart';
@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase, this._googleSignInUseCase) : super(const LoginInitial());
  final LoginUseCase _loginUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  Future<void> login(LoginEntity entity) async {
    emit(const LoginLoading());
    try {
      await _loginUseCase(entity);
      emit(const LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
  Future<void> signInWithGoogle() async {
    emit(const LoginLoading());
    try {
      await _googleSignInUseCase();
      emit(const LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}