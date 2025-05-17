abstract interface class IAdRepository {
  Future<void> showInterstitialAd({required void Function() onClose, required void Function() onError});

  bool get hasInterstitialAd;
}