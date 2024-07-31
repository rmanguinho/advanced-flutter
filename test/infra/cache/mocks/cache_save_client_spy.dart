import 'package:advanced_flutter/infra/cache/clients/cache_save_client.dart';

final class CacheSaveClientSpy implements CacheSaveClient {
  String? key;
  dynamic value;

  @override
  Future<void> save({ required String key, required dynamic value }) async {
    this.key = key;
    this.value = value;
  }
}
