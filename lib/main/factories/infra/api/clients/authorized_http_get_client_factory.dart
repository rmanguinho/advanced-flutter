import 'package:advanced_flutter/infra/api/clients/authorized_http_get_client.dart';
import 'package:advanced_flutter/main/factories/infra/api/adapters/http_adapter_factory.dart';
import 'package:advanced_flutter/main/factories/infra/cache/adapters/cache_manager_adapter_factory.dart';

AuthorizedHttpGetClient makeAuthorizedHttpGetClient() {
  return AuthorizedHttpGetClient(
    cacheClient: makeCacheManagerAdapter(),
    httpClient: makeHttpAdapter()
  );
}
