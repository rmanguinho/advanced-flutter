import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../cache/mocks/cache_get_client_spy.dart';

final class AuthorizedHttpGetClient {
  final CacheGetClient cacheClient;

  const AuthorizedHttpGetClient({
    required this.cacheClient
  });

  Future<void> get() async {
    await cacheClient.get(key: 'current_user');
  }
}

void main() {
  late CacheGetClientSpy cacheClient;
  late AuthorizedHttpGetClient sut;

  setUp(() {
    cacheClient = CacheGetClientSpy();
    sut = AuthorizedHttpGetClient(cacheClient: cacheClient);
  });

  test('should call CacheClient with correct input', () async {
    await sut.get();
    expect(cacheClient.callsCount, 1);
    expect(cacheClient.key, 'current_user');
  });
}