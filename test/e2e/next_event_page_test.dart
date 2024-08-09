import 'package:advanced_flutter/infra/api/adapters/http_adapter.dart';
import 'package:advanced_flutter/infra/api/repositories/load_next_event_api_repo.dart';
import 'package:advanced_flutter/infra/mappers/next_event_mapper.dart';
import 'package:advanced_flutter/infra/mappers/next_event_player_mapper.dart';
import 'package:advanced_flutter/presentation/rx/next_event_rx_presenter.dart';
import 'package:advanced_flutter/ui/pages/next_event_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../infra/api/mocks/client_spy.dart';
import '../mocks/fakes.dart';

void main() {
  testWidgets('should present next event page', (tester) async {
    final client = ClientSpy();
    client.responseJson = '''
      {
        "id": "1",
        "groupName": "Pelada Chega+",
        "date": "2024-01-11T11:10:00.000Z",
        "players": [{
          "id": "1",
          "name": "Cristiano Ronaldo",
          "position": "forward",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T11:07:00.000Z"
        }, {
          "id": "2",
          "name": "Lionel Messi",
          "position": "midfielder",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T11:08:00.000Z"
        }, {
          "id": "3",
          "name": "Dida",
          "position": "goalkeeper",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T09:10:00.000Z"
        }, {
          "id": "4",
          "name": "Romario",
          "position": "forward",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T11:10:00.000Z"
        }, {
          "id": "5",
          "name": "Claudio Gamarra",
          "position": "defender",
          "isConfirmed": false,
          "confirmationDate": "2024-01-10T13:10:00.000Z"
        }, {
          "id": "6",
          "name": "Diego Forlan",
          "position": "defender",
          "isConfirmed": false,
          "confirmationDate": "2024-01-10T14:10:00.000Z"
        }, {
          "id": "7",
          "name": "Zé Ninguém",
          "isConfirmed": false
        }, {
          "id": "8",
          "name": "Rodrigo Manguinho",
          "isConfirmed": false
        }, {
          "id": "9",
          "name": "Claudio Taffarel",
          "position": "goalkeeper",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T09:15:00.000Z"
        }]
      }
    ''';
    final httpClient = HttpAdapter(client: client);
    final repo = LoadNextEventApiRepository(
      httpClient: httpClient,
      url: anyString(),
      mapper: NextEventMapper(playerMapper: NextEventPlayerMapper())
    );
    final presenter = NextEventRxPresenter(nextEventLoader: repo.loadNextEvent);
    final sut = MaterialApp(home: NextEventPage(presenter: presenter, groupId: anyString()));
    await tester.pumpWidget(sut);
    await tester.pump();
    await tester.ensureVisible(find.text('Cristiano Ronaldo', skipOffstage: false));
    await tester.pump();
    expect(find.text('Cristiano Ronaldo'), findsOneWidget);
    await tester.ensureVisible(find.text('Lionel Messi', skipOffstage: false));
    await tester.pump();
    expect(find.text('Lionel Messi'), findsOneWidget);
    await tester.ensureVisible(find.text('Claudio Gamarra', skipOffstage: false));
    await tester.pump();
    expect(find.text('Claudio Gamarra'), findsOneWidget);
  });
}
