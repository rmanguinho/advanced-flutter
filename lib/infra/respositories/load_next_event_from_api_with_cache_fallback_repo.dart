import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_save_client.dart';
import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';

typedef LoadNextEventRepository = Future<NextEvent> Function({ required String groupId });

final class LoadNextEventFromApiWithCacheFallbackRepository {
  final LoadNextEventRepository loadNextEventFromApi;
  final LoadNextEventRepository loadNextEventFromCache;
  final CacheSaveClient cacheClient;
  final String key;

  const LoadNextEventFromApiWithCacheFallbackRepository({
    required this.loadNextEventFromApi,
    required this.loadNextEventFromCache,
    required this.cacheClient,
    required this.key
  });

  Future<NextEvent> loadNextEvent({ required String groupId }) async {
    try {
      final event = await loadNextEventFromApi(groupId: groupId);
      final json = NextEventMapper().toJson(event);
      await cacheClient.save(key: '$key:$groupId', value: json);
      return event;
    } on SessionExpiredError {
      rethrow;
    } catch (error) {
      return loadNextEventFromCache(groupId: groupId);
    }
  }
}
