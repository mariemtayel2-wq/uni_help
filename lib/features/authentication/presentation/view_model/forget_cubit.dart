 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/forget_entity.dart';
import 'package:uni_help/features/authentication/domain/use_case/forget_pass_use_case.dart';
import 'package:uni_help/features/authentication/presentation/view_model/forget_state_cubit.dart';
@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPasswordUseCase) : super(const ForgotPasswordInitial());
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  Future<void> forgotPassword(ForgotPasswordEntity entity) async {
    emit(const ForgotPasswordLoading());
    try {
      await _forgotPasswordUseCase(entity);
      emit(const ForgotPasswordSuccess('Password reset link sent to your email'));
    } catch (e) {
      emit(ForgotPasswordError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}