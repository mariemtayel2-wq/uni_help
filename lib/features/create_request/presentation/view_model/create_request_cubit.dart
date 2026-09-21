import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/create_request/domain/entity/request_entity.dart';
import 'package:uni_help/features/create_request/domain/use_case/create_request_use_case.dart';
import 'create_request_state_cubit.dart';

@injectable
class CreateRequestCubit extends Cubit<CreateRequestStateCubit> {
  final CreateRequestUseCase createRequestUseCase;

  CreateRequestCubit({required this.createRequestUseCase}) : super(CreateRequestStateInitial());

  Future<void> submitRequest({
    required String title,
    required String description,
    required String category,
    required String skillNeeded,
    required String userId,
    File? attachment,
    DateTime? preferredTime,
  }) async {
    emit(CreateRequestStateLoading());
    try {
      final requestEntity = RequestEntity(
        title: title,
        description: description,
        category: category,
        skillNeeded: skillNeeded,
        userId: userId,
        preferredTime: preferredTime,
        createdAt: DateTime.now(),
      );

      await createRequestUseCase(requestEntity, attachment);
      emit(CreateRequestStateSuccess());
    } catch (e) {
      emit(CreateRequestStateError(e.toString()));
    }
  }
}