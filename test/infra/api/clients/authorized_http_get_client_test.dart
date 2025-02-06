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

  Future<void> get({ required String url, Json? params, Json? queryString, Json? headers }) async {
    final user = await cacheClient.get(key: 'current_user');
    if (user?['accessToken'] != null) headers = (headers ?? {})..addAll({ 'authorization': user['accessToken'] });
    await httpClient.get(url: url, params: params, queryString: queryString, headers: headers);
  }
}

void main() {
  late CacheGetClientSpy cacheClient;
  late HttpGetClientSpy httpClient;
  late AuthorizedHttpGetClient sut;
  late String url;
  late Json params;
  late Json queryString;
  late Json headers;
  late String token;

  setUp(() {
    url = anyString();
    token = anyString();
    params = anyJson();
    queryString = anyJson();
    headers = anyJson();
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

  test('should call HttpClient with null headers', () async {
    cacheClient.response = null;
    await sut.get(url: url, headers: null);
    expect(httpClient.headers, isNull);
  });

  test('should call HttpClient with current headers', () async {
    cacheClient.response = null;
    await sut.get(url: url, headers: headers);
    expect(httpClient.headers, headers);
  });

  test('should call HttpClient with authorization headers', () async {
    cacheClient.response = { 'accessToken': token };
    await sut.get(url: url, headers: null);
    expect(httpClient.headers, { 'authorization': token });
  });

  test('should call HttpClient with merged headers', () async {
    cacheClient.response = { 'accessToken': token };
    await sut.get(url: url, headers: { 'q1': 'v1', 'q2': 'v2' });
    expect(httpClient.headers, { 'authorization': token, 'q1': 'v1', 'q2': 'v2' });
  });

  test('should call HttpClient with invalid cache', () async {
    cacheClient.response = { 'invalid': 'invalid' };
    await sut.get(url: url, headers: { 'q1': 'v1', 'q2': 'v2' });
    expect(httpClient.headers, { 'q1': 'v1', 'q2': 'v2' });
  });

  test('should call HttpClient with invalid cache and null headers', () async {
    cacheClient.response = { 'invalid': 'invalid' };
    await sut.get(url: url, headers: null);
    expect(httpClient.headers, isNull);
  });
}