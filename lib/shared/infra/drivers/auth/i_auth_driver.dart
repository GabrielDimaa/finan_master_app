abstract class IAuthDriver {
  Future<void> createUserWithEmailAndPassword();

  Future<void> loginWithEmailAndPassword({required String email, required String password});

  Future<void> loginWithGoogle();

  Future<void> sendVerificationEmail(String userId);

  Future<bool> checkEmailVerified(String userId);
}
