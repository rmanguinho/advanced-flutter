import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/infra/api/repositories/load_next_event_api_repo.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../mocks/http_get_client_spy.dart';

void main() {
  late String groupId;
  late String url;
  late HttpGetClientSpy httpClient;
  late LoadNextEventApiRepository sut;

  setUp(() {
    groupId = anyString();
    url = anyString();
    httpClient = HttpGetClientSpy();
    httpClient.response = {
      'groupName': 'any name',
      'date': '2024-08-30T10:30',
      'players': [{
        'id': 'id 1',
        'name': 'name 1',
        'isConfirmed': true
      }, {
        'id': 'id 2',
        'name': 'name 2',
        'position': 'position 2',
        'photo': 'photo 2',
        'confirmationDate': '2024-08-29T11:00',
        'isConfirmed': false
      }]
    };
    sut = LoadNextEventApiRepository(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.url, url);
    expect(httpClient.params, { 'groupId': groupId });
    expect(httpClient.callsCount, 1);
  });

  test('should return NextEvent on success', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event.groupName, 'any name');
    expect(event.date, DateTime(2024, 8, 30, 10, 30));
    expect(event.players[0].id, 'id 1');
    expect(event.players[0].name, 'name 1');
    expect(event.players[0].isConfirmed, true);
    expect(event.players[1].id, 'id 2');
    expect(event.players[1].name, 'name 2');
    expect(event.players[1].position, 'position 2');
    expect(event.players[1].photo, 'photo 2');
    expect(event.players[1].confirmationDate, DateTime(2024, 8, 29, 11, 0));
    expect(event.players[1].isConfirmed, false);
  });

  test('should rethrow on error', () async {
    final error = Error();
    httpClient.error = error;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(error));
  });

  test('should throw UnexpectedError on null response', () async {
    httpClient.response = null;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(isA<UnexpectedError>()));
  });
}
