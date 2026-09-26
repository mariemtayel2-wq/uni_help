import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/features/create_request/domain/use_case/create_request_use_case.dart';
import 'package:uni_help/features/create_request/domain/use_case/notify_helpers_about_new_request_use_case.dart';
import 'package:uni_help/features/home_screen/domain/use_case/get_current_user_use_case.dart';
import 'create_request_state_cubit.dart';

@injectable
class CreateRequestCubit extends Cubit<CreateRequestStateCubit> {
  final CreateRequestUseCase createRequestUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final NotifyHelpersAboutNewRequestUseCase notifyHelpersUseCase; // ⬅️ جديد

  CreateRequestCubit({
    required this.createRequestUseCase,
    required this.getCurrentUserUseCase,
    required this.notifyHelpersUseCase,
  }) : super(CreateRequestStateInitial());

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
      final currentUser = await getCurrentUserUseCase();

      final requestEntity = RequestEntity(
        title: title,
        description: description,
        category: category,
        skillNeeded: skillNeeded,
        requesterId: userId,
        preferredTime: preferredTime,
        createdAt: DateTime.now(),
        requesterName: currentUser.fullName,
        requesterInitials: currentUser.initials,
        requesterRating: currentUser.rating,
        requesterRatingCount: currentUser.ratingCount,
      );

      await createRequestUseCase(requestEntity, attachment);

      try {
        await notifyHelpersUseCase(requestEntity);
      } catch (_) {
      }

      emit(CreateRequestStateSuccess());
    } catch (e) {
      emit(CreateRequestStateError(e.toString()));
    }
  }
}