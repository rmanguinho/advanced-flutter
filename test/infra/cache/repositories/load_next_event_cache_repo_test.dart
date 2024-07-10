import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/infra/cache/repositories/load_next_event_cache_repo.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../mocks/cache_get_client_spy.dart';

void main() {
  late String groupId;
  late String key;
  late CacheGetClientSpy cacheClient;
  late LoadNextEventCacheRepository sut;

  setUp(() {
    groupId = anyString();
    key = anyString();
    cacheClient = CacheGetClientSpy();
    cacheClient.response = {
      "groupName": "any name",
      "date": DateTime(2024, 1, 1, 10, 30),
      "players": [{
        "id": "id 1",
        "name": "name 1",
        "isConfirmed": true
      }, {
        "id": "id 2",
        "name": "name 2",
        "position": "position 2",
        "photo": "photo 2",
        "confirmationDate": DateTime(2024, 1, 1, 12, 30),
        "isConfirmed": false
      }]
    };
    sut = LoadNextEventCacheRepository(cacheClient: cacheClient, key: key);
  });

  test('should call CacheClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(cacheClient.key, '$key:$groupId');
    expect(cacheClient.callsCount, 1);
  });

  test('should return NextEvent on success', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event.groupName, 'any name');
    expect(event.date, DateTime(2024, 1, 1, 10, 30));
    expect(event.players[0].id, 'id 1');
    expect(event.players[0].name, 'name 1');
    expect(event.players[0].isConfirmed, true);
    expect(event.players[1].id, 'id 2');
    expect(event.players[1].name, 'name 2');
    expect(event.players[1].position, 'position 2');
    expect(event.players[1].photo, 'photo 2');
    expect(event.players[1].confirmationDate, DateTime(2024, 1, 1, 12, 30));
    expect(event.players[1].isConfirmed, false);
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
    expect(future, throwsA(const TypeMatcher<UnexpectedError>()));
  });
}
