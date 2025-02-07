import 'package:advanced_flutter/infra/api/clients/http_get_client.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter/infra/types/json.dart';

final class AuthorizedHttpGetClient implements HttpGetClient {
  final CacheGetClient cacheClient;
  final HttpGetClient httpClient;

  const AuthorizedHttpGetClient({
    required this.cacheClient,
    required this.httpClient
  });

  @override
  Future<dynamic> get({ required String url, Json? params, Json? queryString, Json? headers }) async {
    final user = await cacheClient.get(key: 'current_user');
    if (user?['accessToken'] != null) headers = (headers ?? {})..addAll({ 'authorization': user['accessToken'] });
    return httpClient.get(url: url, params: params, queryString: queryString, headers: headers);
  }
}
