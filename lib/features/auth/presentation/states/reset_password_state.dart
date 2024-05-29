sealed class ResetPasswordState {
  const ResetPasswordState();

  factory ResetPasswordState.start() => const StartResetPasswordState();

  ResetPasswordState setSendingResetPasswordState() => const SendingResetPasswordState();

  ResetPasswordState setSentResetPasswordState() => const SentResetPasswordState();

  ResetPasswordState setError(Object error) => ErrorResetPasswordState(error);
}

class StartResetPasswordState extends ResetPasswordState {
  const StartResetPasswordState();
}

class SendingResetPasswordState extends ResetPasswordState {
  const SendingResetPasswordState();
}

class SentResetPasswordState extends ResetPasswordState {
  const SentResetPasswordState();
}

class ErrorResetPasswordState extends ResetPasswordState {
  final Object error;

  String get message => error.toString().replaceAll('Exception: ', '');

  ErrorResetPasswordState(this.error);
}
