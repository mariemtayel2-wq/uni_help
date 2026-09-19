import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';
import 'package:uni_help/features/authentication/domain/use_case/register_use_case.dart';
import 'package:uni_help/features/authentication/presentation/view_model/register_state_cubit.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUseCase) : super(const RegisterInitial());
 
  final RegisterUseCase _registerUseCase;
 
  Future<void> register(RegisterEntity entity) async {
    emit(const RegisterLoading());
 
    try {
      await _registerUseCase(entity);
      emit(const RegisterSuccess('Account created successfully'));
    } catch (e) {
      emit(RegisterError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}