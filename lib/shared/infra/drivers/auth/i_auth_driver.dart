abstract class IAuthDriver {
  Future<void> createUserWithEmailAndPassword();

  Future<void> loginWithEmailAndPassword({required String email, required String password});

  Future<String?> loginWithGoogle();

  Future<void> sendVerificationEmail(String userId);

  Future<bool> checkEmailVerified(String userId);
}
