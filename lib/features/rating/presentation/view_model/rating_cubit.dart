import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/rating_entity.dart';
import 'package:uni_help/features/home_screen/domain/use_case/get_current_user_use_case.dart';
import 'package:uni_help/features/profile_screen/domain/use_case/submit_rating_use_case.dart';
import 'package:uni_help/features/rating/presentation/view_model/rating_state_cubit.dart';


@injectable
class RateHelperCubit extends Cubit<RateHelperStateCubit> {
  RateHelperCubit(this._submitRatingUseCase, this._getCurrentUserUseCase)
      : super(RateHelperStateIdle());

  final SubmitRatingUseCase _submitRatingUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> submit({
    required String targetUserId,
    required int stars,
    String? comment,
    String? requestId,
  }) async {
    emit(RateHelperStateSubmitting());
    try {
      final currentUser = await _getCurrentUserUseCase();
      final rating = RatingEntity(
        raterId: FirebaseAuth.instance.currentUser!.uid,
        raterName: currentUser.fullName,
        targetUserId: targetUserId,
        stars: stars,
        comment: (comment?.trim().isEmpty ?? true) ? null : comment!.trim(),
        createdAt: DateTime.now(),
        requestId: requestId,
      );
      await _submitRatingUseCase(rating);
      emit(RateHelperStateSuccess());
    } catch (e) {
      emit(RateHelperStateError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}