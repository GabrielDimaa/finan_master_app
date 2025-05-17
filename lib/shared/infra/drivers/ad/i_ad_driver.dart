abstract interface class IAdDriver {
  Future<void> loadInterstitialAd();

  Future<void> showInterstitialAd({required void Function() onClose, required void Function() onError});

  bool get hasInterstitialAd;
}
