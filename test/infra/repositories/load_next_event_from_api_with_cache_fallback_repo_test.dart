import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';

final class LoadNextEventFromApiWithCacheFallbackRepository {
  final Future<void> Function({ required String groupId }) loadNextEventFromApi;

  const LoadNextEventFromApiWithCacheFallbackRepository({
    required this.loadNextEventFromApi
  });

  Future<void> loadNextEvent({ required String groupId }) async {
    await loadNextEventFromApi(groupId: groupId);
  }
}

final class LoadNextEventRepositorySpy {
  String? groupId;
  int callsCount = 0;

  Future<void> loadNextEvent({ required String groupId }) async {
    this.groupId = groupId;
    callsCount++;
  }
}

void main() {
  test('should load event data from api repo', () async {
    final groupId = anyString();
    final apiRepo = LoadNextEventRepositorySpy();
    final sut = LoadNextEventFromApiWithCacheFallbackRepository(
      loadNextEventFromApi: apiRepo.loadNextEvent
    );
    await sut.loadNextEvent(groupId: groupId);
    expect(apiRepo.groupId, groupId);
    expect(apiRepo.callsCount, 1);
  });
}
