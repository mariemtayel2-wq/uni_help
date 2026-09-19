abstract class ResendVerificationState {
  const ResendVerificationState();
}

class ResendVerificationInitial extends ResendVerificationState {
  const ResendVerificationInitial();
}

class ResendVerificationLoading extends ResendVerificationState {
  const ResendVerificationLoading();
}

class ResendVerificationSuccess extends ResendVerificationState {
  const ResendVerificationSuccess();
}

class ResendVerificationError extends ResendVerificationState {
  const ResendVerificationError(this.message);

  final String message;
}