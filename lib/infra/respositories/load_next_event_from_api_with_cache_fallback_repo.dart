import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_save_client.dart';
import 'package:advanced_flutter/infra/mappers/mapper.dart';

typedef LoadNextEventRepository = Future<NextEvent> Function({ required String groupId });

final class LoadNextEventFromApiWithCacheFallbackRepository {
  final LoadNextEventRepository loadNextEventFromApi;
  final LoadNextEventRepository loadNextEventFromCache;
  final CacheSaveClient cacheClient;
  final String key;
  final JsonMapper<NextEvent> mapper;

  const LoadNextEventFromApiWithCacheFallbackRepository({
    required this.loadNextEventFromApi,
    required this.loadNextEventFromCache,
    required this.cacheClient,
    required this.mapper,
    required this.key
  });

  Future<NextEvent> loadNextEvent({ required String groupId }) async {
    try {
      final event = await loadNextEventFromApi(groupId: groupId);
      await cacheClient.save(key: '$key:$groupId', value: mapper.toJson(event));
      return event;
    } on SessionExpiredError {
      rethrow;
    } catch (error) {
      return loadNextEventFromCache(groupId: groupId);
    }
  }
}
