import 'package:advanced_flutter/infra/api/repositories/load_next_event_api_repo.dart';
import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';
import 'package:advanced_flutter/infra/mappers/next_event_player_mapper.dart';
import 'package:advanced_flutter/main/factories/infra/api/adapters/http_adapter_factory.dart';

LoadNextEventApiRepository makeLoadNextEventApiRepository() {
  return LoadNextEventApiRepository(
    httpClient: makeHttpAdapter(),
    url: 'http://10.0.2.2:8080/api/groups/:groupId/next_event',
    mapper: NextEventMapper(playerMapper: NextEventPlayerMapper())
  );
}
