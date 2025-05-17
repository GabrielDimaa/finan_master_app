import 'package:finan_master_app/features/ad/domain/repositories/i_ad_access_repository.dart';
import 'package:finan_master_app/features/ad/domain/use_cases/i_ad_access.dart';

class AdAccess implements IAdAccess {
  final IAdAccessRepository _repository;

  AdAccess({required IAdAccessRepository repository}) : _repository = repository;

  static const _kFirstUsesRemaining = 7;
  static const _kUsesRemaining = 5;

  @override
  Future<void> consumeUse() async {
    final int usesRemaining = _repository.findUsesRemaining() ?? _kFirstUsesRemaining;

    await _repository.saveUsesRemaining(usesRemaining - 1);
  }

  @override
  bool canShowAd() {
    final int? usesRemaining = _repository.findUsesRemaining();

    if (usesRemaining == null) {
      _repository.saveUsesRemaining(_kFirstUsesRemaining);
      return false;
    }

    return usesRemaining <= 0;
  }

  @override
  Future<void> saveUsesRemaining() => _repository.saveUsesRemaining(_kUsesRemaining);
}
