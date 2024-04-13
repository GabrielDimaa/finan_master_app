abstract interface class IAuthRepository {
  Future<void> loginWithEmailAndPassword({required String email, required String password});

  Future<void> loginWithGoogle();
}
