import 'package:advanced_flutter/domain/entities/next_event.dart';

import '../../mocks/fakes.dart';

final class LoadNextEventRepositorySpy {
  String? groupId;
  int callsCount = 0;
  NextEvent output = NextEvent(groupName: anyString(), date: anyDate(), players: []);
  Object? error;

  Future<NextEvent> loadNextEvent({ required String groupId }) async {
    this.groupId = groupId;
    callsCount++;
    if (error != null) throw error!;
    return output;
  }
}
