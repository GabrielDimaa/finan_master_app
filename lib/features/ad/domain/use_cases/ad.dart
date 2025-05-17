import 'package:finan_master_app/features/ad/domain/repositories/i_ad_repository.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';

class Ad implements IAd {
  final IAdRepository _repository;
  final IAdAccess _adAccess;

  Ad({required IAdRepository repository, required IAdAccess adAccess})
      : _repository = repository,
        _adAccess = adAccess;

  @override
  Future<void> showInterstitialAd({required void Function() onClose}) async {
    await _repository.showInterstitialAd(
      onClose: () {
        _adAccess.saveUsesRemaining();
        onClose();
      },
      onError: onClose,
    );
  }

  @override
  bool get hasInterstitialAd => _repository.hasInterstitialAd;
}
