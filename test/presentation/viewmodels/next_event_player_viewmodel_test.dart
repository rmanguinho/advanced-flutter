import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/presentation/viewmodels/next_event_player_viewmodel.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

void main() {
  test('should build doubt list sorted by name', () async {
    final doubt = NextEventPlayerViewModel.mapDoubtPlayers([
      NextEventPlayer(id: anyString(), name: 'C', isConfirmed: anyBool()),
      NextEventPlayer(id: anyString(), name: 'A', isConfirmed: anyBool()),
      NextEventPlayer(id: anyString(), name: 'B', isConfirmed: anyBool(), confirmationDate: anyDate()),
      NextEventPlayer(id: anyString(), name: 'D', isConfirmed: anyBool())
    ]);
    expect(doubt.length, 3);
    expect(doubt[0].name, 'A');
    expect(doubt[1].name, 'C');
    expect(doubt[2].name, 'D');
  });

  test('should build out list sorted by confirmation date', () async {
    final out = NextEventPlayerViewModel.mapOutPlayers([
      NextEventPlayer(id: anyString(), name: 'C', isConfirmed: false, confirmationDate: DateTime(2024, 1, 1, 10)),
      NextEventPlayer(id: anyString(), name: 'A', isConfirmed: anyBool()),
      NextEventPlayer(id: anyString(), name: 'B', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 11)),
      NextEventPlayer(id: anyString(), name: 'E', isConfirmed: false, confirmationDate: DateTime(2024, 1, 1, 9)),
      NextEventPlayer(id: anyString(), name: 'D', isConfirmed: false, confirmationDate: DateTime(2024, 1, 1, 12))
    ]);
    expect(out.length, 3);
    expect(out[0].name, 'E');
    expect(out[1].name, 'C');
    expect(out[2].name, 'D');
  });

  test('should build goalkeepers list sorted by confirmation date', () async {
    final goalkeepers = NextEventPlayerViewModel.mapGoalkeepers([
      NextEventPlayer(id: anyString(), name: 'C', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 10), position: 'goalkeeper'),
      NextEventPlayer(id: anyString(), name: 'A', isConfirmed: anyBool()),
      NextEventPlayer(id: anyString(), name: 'B', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 11), position: 'defender'),
      NextEventPlayer(id: anyString(), name: 'E', isConfirmed: false, confirmationDate: DateTime(2024, 1, 1, 9)),
      NextEventPlayer(id: anyString(), name: 'D', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 12)),
      NextEventPlayer(id: anyString(), name: 'F', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 8), position: 'goalkeeper')
    ]);
    expect(goalkeepers.length, 2);
    expect(goalkeepers[0].name, 'F');
    expect(goalkeepers[1].name, 'C');
  });

  test('should build players list sorted by confirmation date', () async {
    final players = NextEventPlayerViewModel.mapInPlayers([
      NextEventPlayer(id: anyString(), name: 'C', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 10), position: 'goalkeeper'),
      NextEventPlayer(id: anyString(), name: 'A', isConfirmed: anyBool()),
      NextEventPlayer(id: anyString(), name: 'B', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 11), position: 'defender'),
      NextEventPlayer(id: anyString(), name: 'E', isConfirmed: false, confirmationDate: DateTime(2024, 1, 1, 9)),
      NextEventPlayer(id: anyString(), name: 'D', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 12)),
      NextEventPlayer(id: anyString(), name: 'F', isConfirmed: true, confirmationDate: DateTime(2024, 1, 1, 8), position: 'goalkeeper')
    ]);
    expect(players.length, 2);
    expect(players[0].name, 'B');
    expect(players[1].name, 'D');
  });

  test('should map player without confirmation date', () async {
    final player = NextEventPlayer(id: anyString(), name: anyString(), isConfirmed: anyBool(), photo: anyString(), position: anyString(), confirmationDate: null);
    final viewmodel = NextEventPlayerViewModel.fromEntity(player);
    expect(viewmodel.name, player.name);
    expect(viewmodel.initials, player.initials);
    expect(viewmodel.isConfirmed, null);
    expect(viewmodel.photo, player.photo);
    expect(viewmodel.position, player.position);
  });

  test('should map player with confirmation date', () async {
    final player = NextEventPlayer(id: anyString(), name: anyString(), isConfirmed: anyBool(), photo: anyString(), position: anyString(), confirmationDate: anyDate());
    final viewmodel = NextEventPlayerViewModel.fromEntity(player);
    expect(viewmodel.name, player.name);
    expect(viewmodel.initials, player.initials);
    expect(viewmodel.isConfirmed, player.isConfirmed);
    expect(viewmodel.photo, player.photo);
    expect(viewmodel.position, player.position);
  });
}
