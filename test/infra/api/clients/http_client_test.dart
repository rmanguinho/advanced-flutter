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
  late ClientSpy client;
  late HttpClient sut;

  setUp(() {
    client = ClientSpy();
    sut = HttpClient(client: client);
  });

  group('get', () {
    test('should request with correct method', () async {
      await sut.get();
      expect(client.method, 'get');
      expect(client.callsCount, 1);
    });
  });

}
