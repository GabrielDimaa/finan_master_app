import 'package:finan_master_app/features/ad/domain/repositories/i_ad_repository.dart';
import 'package:finan_master_app/shared/infra/drivers/ad/i_ad_driver.dart';

class AdRepository implements IAdRepository {
  final IAdDriver _driver;

  AdRepository({required IAdDriver driver}) : _driver = driver;

  @override
  Future<void> showInterstitialAd({required void Function() onClose, required void Function() onError}) => _driver.showInterstitialAd(onClose: onClose, onError: onError);

  @override
  bool get hasInterstitialAd => _driver.hasInterstitialAd;
}
