import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/use_case/resend_email_verification_use_case.dart';
import 'package:uni_help/features/authentication/presentation/view_model/resend_verficattion_state.dart';


@injectable
class ResendVerificationCubit extends Cubit<ResendVerificationState> {
  ResendVerificationCubit(this._resendVerificationEmailUseCase) : super(const ResendVerificationInitial());

  final ResendVerificationEmailUseCase _resendVerificationEmailUseCase;

  Future<void> resend() async {
    emit(const ResendVerificationLoading());

    try {
      await _resendVerificationEmailUseCase();
      emit(const ResendVerificationSuccess());
    } catch (e) {
      emit(ResendVerificationError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}