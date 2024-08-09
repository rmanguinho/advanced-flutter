import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter/infra/mappers/mapper.dart';

final class LoadNextEventCacheRepository {
  final CacheGetClient cacheClient;
  final String key;
  final DtoMapper<NextEvent> mapper;

  const LoadNextEventCacheRepository({
    required this.cacheClient,
    required this.key,
    required this.mapper
  });

  Future<NextEvent> loadNextEvent({ required String groupId }) async {
    final json = await cacheClient.get(key: '$key:$groupId');
    if (json == null) throw UnexpectedError();
    return mapper.toDto(json);
  }
}
