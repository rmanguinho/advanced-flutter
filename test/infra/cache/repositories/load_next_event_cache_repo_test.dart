import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/cache/repositories/load_next_event_cache_repo.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../../mocks/mapper_spy.dart';
import '../mocks/cache_get_client_spy.dart';

void main() {
  late String groupId;
  late String key;
  late CacheGetClientSpy cacheClient;
  late MapperSpy<NextEvent> mapper;
  late LoadNextEventCacheRepository sut;

  setUp(() {
    groupId = anyString();
    key = anyString();
    cacheClient = CacheGetClientSpy();
    mapper = MapperSpy(toDtoOutput: anyNextEvent());
    sut = LoadNextEventCacheRepository(cacheClient: cacheClient, key: key, mapper: mapper);
  });

  test('should call CacheClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(cacheClient.key, '$key:$groupId');
    expect(cacheClient.callsCount, 1);
  });

  test('should return NextEvent on success', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(mapper.toDtoIntput, cacheClient.response);
    expect(mapper.toDtoIntputCallsCount, 1);
    expect(event, mapper.toDtoOutput);
  });

  test('should rethrow on error', () async {
    final error = Error();
    cacheClient.error = error;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(error));
  });

  test('should throw UnexpectedError on null response', () async {
    cacheClient.response = null;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(isA<UnexpectedError>()));
  });
}
