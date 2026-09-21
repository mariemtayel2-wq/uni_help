abstract class CreateRequestStateCubit {}
class CreateRequestStateInitial extends CreateRequestStateCubit {}
class CreateRequestStateLoading extends CreateRequestStateCubit {}
class CreateRequestStateSuccess extends CreateRequestStateCubit {}
class CreateRequestStateError extends CreateRequestStateCubit {
  final String message;

  CreateRequestStateError(this.message);
}