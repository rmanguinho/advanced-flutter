import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/respositories/load_next_event_from_api_with_cache_fallback_repo.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';
import '../cache/mocks/cache_save_client_mock.dart';
import '../mocks/load_next_event_repo_spy.dart';
import '../mocks/mapper_spy.dart';

void main() {
  late String groupId;
  late String key;
  late LoadNextEventRepositorySpy apiRepo;
  late LoadNextEventRepositorySpy cacheRepo;
  late CacheSaveClientMock cacheClient;
  late MapperSpy<NextEvent> mapper;
  late LoadNextEventFromApiWithCacheFallbackRepository sut;

  setUp(() {
    groupId = anyString();
    key = anyString();
    apiRepo = LoadNextEventRepositorySpy();
    cacheRepo = LoadNextEventRepositorySpy();
    cacheClient = CacheSaveClientMock();
    mapper = MapperSpy(toDtoOutput: anyNextEvent());
    sut = LoadNextEventFromApiWithCacheFallbackRepository(
      key: key,
      cacheClient: cacheClient,
      loadNextEventFromApi: apiRepo.loadNextEvent,
      loadNextEventFromCache: cacheRepo.loadNextEvent,
      mapper: mapper
    );
  });

  test('should load event data from api repo', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(apiRepo.groupId, groupId);
    expect(apiRepo.callsCount, 1);
  });

  test('should save event data from api on cache', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(cacheClient.key, '$key:$groupId');
    expect(cacheClient.value, mapper.toJsonOutput);
    expect(mapper.toJsonIntput, apiRepo.output);
    expect(mapper.toJsonCallsCount, 1);
  });

  test('should return api data on success', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event, apiRepo.output);
  });

  test('should rethrow api error when its SessionExpiredError', () async {
    apiRepo.error = SessionExpiredError();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(apiRepo.error));
  });

  test('should load event data from cache repo when api fails', () async {
    apiRepo.error = Error();
    await sut.loadNextEvent(groupId: groupId);
    expect(cacheRepo.groupId, groupId);
    expect(cacheRepo.callsCount, 1);
  });

  test('should return cache data when api fails', () async {
    apiRepo.error = Error();
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event, cacheRepo.output);
  });

  test('should rethrow cache error when api and cache fails', () async {
    apiRepo.error = Error();
    cacheRepo.error = Error();
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(cacheRepo.error));
  });
}
