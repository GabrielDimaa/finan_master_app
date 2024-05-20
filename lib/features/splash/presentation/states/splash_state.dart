sealed class SplashState {
  const SplashState();

  factory SplashState.start() => const StartSplashState();

  SplashState setError(String message) => ErrorSplashState(message);
}

class StartSplashState extends SplashState {
  const StartSplashState();
}

class ErrorSplashState extends SplashState {
  final String message;

  const ErrorSplashState(this.message);
}