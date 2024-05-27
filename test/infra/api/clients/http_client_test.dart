import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'client_spy.dart';

class HttpClient {
  final Client client;

  HttpClient({
    required this.client
  });

  Future<void> get() async {
    await client.get(Uri());
  }
}

void main() {
  test('should request with correct method', () async {
    final client = ClientSpy();
    final sut = HttpClient(client: client);
    await sut.get();
    expect(client.method, 'get');
    expect(client.callsCount, 1);
  });
}
