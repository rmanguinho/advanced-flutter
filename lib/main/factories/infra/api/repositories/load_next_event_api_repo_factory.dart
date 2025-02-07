import 'package:advanced_flutter/infra/api/repositories/load_next_event_api_repo.dart';
import 'package:advanced_flutter/main/factories/infra/api/clients/api_url_factory.dart';
import 'package:advanced_flutter/main/factories/infra/api/clients/authorized_http_get_client_factory.dart';
import 'package:advanced_flutter/main/factories/infra/mappers/next_event_mapper_factory.dart';

LoadNextEventApiRepository makeLoadNextEventApiRepository() {
  return LoadNextEventApiRepository(
    httpClient: makeAuthorizedHttpGetClient(),
    url: makeApiUrl('groups/:groupId/next_event'),
    mapper: makeNextEventMapper()
  );
}
