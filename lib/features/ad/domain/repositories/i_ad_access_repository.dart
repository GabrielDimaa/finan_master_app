abstract interface class IAdAccessRepository {
  int? findUsesRemaining();

  Future<void> saveUsesRemaining(int value);
}
