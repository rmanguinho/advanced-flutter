import 'package:advanced_flutter/infra/api/clients/http_get_client.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter/infra/types/json.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../../cache/mocks/cache_get_client_spy.dart';
import '../mocks/http_get_client_spy.dart';

final class AuthorizedHttpGetClient {
  final CacheGetClient cacheClient;
  final HttpGetClient httpClient;

  const AuthorizedHttpGetClient({
    required this.cacheClient,
    required this.httpClient
  });

  Future<void> get({ required String url, Json? params, Json? queryString }) async {
    await cacheClient.get(key: 'current_user');
    await httpClient.get(url: url, params: params, queryString: queryString);
  }
}

void main() {
  late CacheGetClientSpy cacheClient;
  late HttpGetClientSpy httpClient;
  late AuthorizedHttpGetClient sut;
  late String url;
  late Json params;
  late Json queryString;

  setUp(() {
    url = anyString();
    params = anyJson();
    queryString = anyJson();
    cacheClient = CacheGetClientSpy();
    httpClient = HttpGetClientSpy();
    sut = AuthorizedHttpGetClient(cacheClient: cacheClient, httpClient: httpClient);
  });

  test('should call CacheClient with correct input', () async {
    await sut.get(url: url);
    expect(cacheClient.callsCount, 1);
    expect(cacheClient.key, 'current_user');
  });

  test('should call HttpClient with correct input', () async {
    await sut.get(url: url, params: params, queryString: queryString);
    expect(httpClient.callsCount, 1);
    expect(httpClient.url, url);
    expect(httpClient.params, params);
    expect(httpClient.queryString, queryString);
  });
}