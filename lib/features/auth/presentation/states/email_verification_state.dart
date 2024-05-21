sealed class EmailVerificationState {
  const EmailVerificationState();

  factory EmailVerificationState.start() => const StartEmailVerificationState();

  EmailVerificationState setResendEmailState() => const ResendEmailVerificationState();

  EmailVerificationState setResendingEmailState() => const ResendingEmailVerificationState();

  EmailVerificationState setCompletingRegistrationState() => const CompletingRegistrationState();

  EmailVerificationState setError(Object error) => ErrorEmailVerificationState(error);
}

class StartEmailVerificationState extends EmailVerificationState {
  const StartEmailVerificationState();
}

class ResendEmailVerificationState extends EmailVerificationState {
  const ResendEmailVerificationState();
}

class ResendingEmailVerificationState extends EmailVerificationState {
  const ResendingEmailVerificationState();
}

class CompletingRegistrationState extends EmailVerificationState {
  const CompletingRegistrationState();
}

class ErrorEmailVerificationState extends EmailVerificationState {
  final Object error;

  String get message => error.toString().replaceAll('Exception: ', '');

  ErrorEmailVerificationState(this.error);
}
