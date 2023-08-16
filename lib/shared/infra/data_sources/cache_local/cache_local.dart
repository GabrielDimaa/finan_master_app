import 'package:finan_master_app/shared/infra/data_sources/cache_local/i_cache_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheLocal implements ICacheLocal {
  final SharedPreferences _sharedPreferences;

  CacheLocal({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;

  @override
  T? get<T>(String key) => _sharedPreferences.get(key) as T?;

  @override
  Future<void> save<T>(String key, T value) async {
    await switch (T) {
      double => _sharedPreferences.setDouble(key, value as double),
      int => _sharedPreferences.setInt(key, value as int),
      bool => _sharedPreferences.setBool(key, value as bool),
      String => _sharedPreferences.setString(key, value as String),
      const (List<String>) => _sharedPreferences.setStringList(key, value as List<String>),
      _ => throw UnimplementedError(),
    };
  }
}
