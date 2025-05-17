import 'package:finan_master_app/features/ad/domain/repositories/i_ad_access_repository.dart';
import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';

class AdAccessRepository implements IAdAccessRepository {
  final ICacheLocal _cacheLocal;

  AdAccessRepository({required ICacheLocal cacheLocal}) : _cacheLocal = cacheLocal;

  static const String adAccessUsesRemainingKey = "ad_access_uses_remaining";

  @override
  int? findUsesRemaining() => _cacheLocal.get<int>(adAccessUsesRemainingKey);

  @override
  Future<void> saveUsesRemaining(int value) => _cacheLocal.save(adAccessUsesRemainingKey, value);
}
