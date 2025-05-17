abstract interface class IAdAccess {
  Future<void> consumeUse();

  bool canShowAd();

  Future<void> saveUsesRemaining();
}
