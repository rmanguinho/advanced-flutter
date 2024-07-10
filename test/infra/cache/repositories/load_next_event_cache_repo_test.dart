import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';

final class CacheGetClientSpy implements CacheGetClient {
  String? key;
  int callsCount = 0;
  dynamic response;
  Error? error;

  @override
  Future<dynamic> get({ required String key }) async {
    this.key = key;
    callsCount++;
    if (error != null) throw error!;
    return response;
  }
}

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
    return NextEventMapper().toObject(json);
  }
}

final class NextEventMapper extends Mapper<NextEvent> {
  @override
  NextEvent toObject(dynamic json) => NextEvent(
    groupName: json['groupName'],
    date: json['date'],
    players: NextEventPlayerMapper().toList(json['players'])
  );
}

final class NextEventPlayerMapper extends Mapper<NextEventPlayer> {
  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json['id'],
    name: json['name'],
    position: json['position'],
    photo: json['photo'],
    confirmationDate: json['confirmationDate'],
    isConfirmed: json['isConfirmed']
  );
}

abstract base class Mapper<Entity> {
  List<Entity> toList(dynamic arr) => arr.map<Entity>(toObject).toList();
  Entity toObject(dynamic json);
}

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
