abstract interface class ICacheLocal {
  T? get<T>(String key);

  Future<void> save<T>(String key, T value);
}
