abstract interface class IAd {
  Future<void> showInterstitialAd({required void Function() onClose});

  bool get hasInterstitialAd;
}
