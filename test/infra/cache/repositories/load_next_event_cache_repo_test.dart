import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';

final class CacheGetClientSpy implements CacheGetClient {
  String? key;
  int callsCount = 0;

  @override
  Future<void> get({ required String key }) async {
    this.key = key;
    callsCount++;
  }
}

abstract interface class CacheGetClient {
  Future<void> get({ required String key });
}

final class LoadNextEventCacheRepository {
  final CacheGetClient cacheClient;
  final String key;

  const LoadNextEventCacheRepository({
    required this.cacheClient,
    required this.key
  });

  Future<void> loadNextEvent({ required String groupId }) async {
    await cacheClient.get(key: '$key:$groupId');
  }
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
    sut = LoadNextEventCacheRepository(cacheClient: cacheClient, key: key);
  });

  test('should call CacheClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(cacheClient.key, '$key:$groupId');
    expect(cacheClient.callsCount, 1);
  });
}
