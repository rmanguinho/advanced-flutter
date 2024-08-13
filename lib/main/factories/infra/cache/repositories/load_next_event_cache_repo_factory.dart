import 'package:advanced_flutter/infra/cache/repositories/load_next_event_cache_repo.dart';
import 'package:advanced_flutter/main/factories/infra/cache/adapters/cache_manager_adapter_factory.dart';
import 'package:advanced_flutter/main/factories/infra/mappers/next_event_mapper_factory.dart';

LoadNextEventCacheRepository makeLoadNextEventCacheRepository() {
  return LoadNextEventCacheRepository(
    cacheClient: makeCacheManagerAdapter(),
    key: 'next_event',
    mapper: makeNextEventMapper()
  );
}
