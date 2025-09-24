// verification_state.dart
abstract class VerificationState {
  const VerificationState();
}

class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

class VerificationSuccess extends VerificationState {
  final String message;
  
  const VerificationSuccess({
    this.message = 'Email verified successfully!',
  });
}

class VerificationError extends VerificationState {
  final String message;
  
  const VerificationError({
    required this.message,
  });
}

class VerificationCodeResent extends VerificationState {
  const VerificationCodeResent();
}