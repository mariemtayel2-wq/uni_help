abstract class RateHelperStateCubit {}
class RateHelperStateIdle extends RateHelperStateCubit {}
class RateHelperStateSubmitting extends RateHelperStateCubit {}
class RateHelperStateSuccess extends RateHelperStateCubit {}
class RateHelperStateError extends RateHelperStateCubit {
  final String message;
  RateHelperStateError(this.message);
}