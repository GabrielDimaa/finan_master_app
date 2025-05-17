import 'package:finan_master_app/shared/classes/connectivity_network.dart';
import 'package:finan_master_app/shared/infra/drivers/ad/i_ad_driver.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdDriver implements IAdDriver {
  static const String adUnitId = kDebugMode ? 'ca-app-pub-3940256099942544/1033173712' : String.fromEnvironment('AD_UNIT_ID');

  List<InterstitialAd> ads = [];

  bool loading = false;

  @override
  Future<void> loadInterstitialAd() async {
    if (loading) return;

    try {
      await ConnectivityNetwork.hasInternet();

      loading = true;

      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd value) => ads.add(value),
          onAdFailedToLoad: (LoadAdError error) => {},
        ),
      );
    } catch (_) {
      return;
    } finally {
      loading = false;
    }
  }

  @override
  Future<void> showInterstitialAd({required void Function() onClose, required void Function() onError}) async {
    final InterstitialAd? ad = ads.firstOrNull;

    if (ad == null) return;

    try {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          onError();
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          onClose();
        },
      );

      loadInterstitialAd();

      await ad.show();
    } finally {
      ads.remove(ad);
    }
  }

  @override
  bool get hasInterstitialAd => ads.isNotEmpty;
}
