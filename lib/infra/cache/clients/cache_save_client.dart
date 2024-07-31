abstract interface class CacheSaveClient {
  Future<void> save({ required String key, required dynamic value });
}
