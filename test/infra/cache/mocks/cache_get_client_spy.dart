import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';

final class CacheGetClientSpy implements CacheGetClient {
  String? key;
  int callsCount = 0;
  dynamic response;
  Error? error;

  @override
  Future<dynamic> get({ required String key }) async {
    this.key = key;
    callsCount++;
    if (error != null) throw error!;
    return response;
  }
}
