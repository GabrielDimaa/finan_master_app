abstract interface class IResetPassword {
  Future<void> send(String email);
}
