import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';

final class LoadNextEventCacheRepository {
  final CacheGetClient cacheClient;
  final String key;

  const LoadNextEventCacheRepository({
    required this.cacheClient,
    required this.key
  });

  Future<NextEvent> loadNextEvent({ required String groupId }) async {
    final json = await cacheClient.get(key: '$key:$groupId');
    if (json == null) throw UnexpectedError();
    return NextEventMapper().toDto(json);
  }
}
