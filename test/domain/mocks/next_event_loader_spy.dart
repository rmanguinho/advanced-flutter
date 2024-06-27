import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import '../../mocks/fakes.dart';

final class NextEventLoaderSpy {
  int callsCount = 0;
  String? groupId;
  Error? error;
  NextEvent output = NextEvent(groupName: anyString(), date: anyDate(), players: []);

  void simulatePlayers(List<NextEventPlayer> players) => output = NextEvent(groupName: anyString(), date: anyDate(), players: players);

  Future<NextEvent> call({ required String groupId }) async {
    this.groupId = groupId;
    callsCount++;
    if (error != null) throw error!;
    return output;
  }
}
