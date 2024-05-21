import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class LoadNextEventApiRepository {
  final HttpGetClient httpClient;
  final String url;

  LoadNextEventApiRepository({
    required this.httpClient,
    required this.url
  });

  Future<void> loadNextEvent({ required String groupId }) async {
    await httpClient.get(url: url);
  }
}

abstract class HttpGetClient {
  Future<void> get({ required String url });
}

class HttpGetClientSpy implements HttpGetClient {
  String? url;
  int callsCount = 0;

  @override
  Future<void> get({ required String url }) async {
    this.url = url;
    callsCount++;
  }
}

void main() {
  late String groupId;
  late String url;
  late HttpGetClientSpy httpClient;
  late LoadNextEventApiRepository sut;

  setUp(() {
    groupId = anyString();
    url = anyString();
    httpClient = HttpGetClientSpy();
    sut = LoadNextEventApiRepository(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct URL', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.url, url);
    expect(httpClient.callsCount, 1);
  });
}
