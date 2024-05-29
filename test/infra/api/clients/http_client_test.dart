import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../../../helpers/fakes.dart';
import 'client_spy.dart';

class HttpClient {
  final Client client;

  HttpClient({
    required this.client
  });

  Future<void> get({ required String url, Map<String, String>? headers, Map<String, String?>? params }) async {
    final allHeaders = (headers ?? {})..addAll({ 'content-type': 'application/json', 'accept': 'application/json' });
    final uri = _buildUri(url: url, params: params);
    await client.get(uri, headers: allHeaders);
  }

  Uri _buildUri({ required String url, Map<String, String?>? params }) {
    params?.forEach((key, value) => url = url.replaceFirst(':$key', value ?? ''));
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    return Uri.parse(url);
  }
}

void main() {
  late ClientSpy client;
  late HttpClient sut;
  late String url;

  setUp(() {
    client = ClientSpy();
    url = anyString();
    sut = HttpClient(client: client);
  });

  group('get', () {
    test('should request with correct method', () async {
      await sut.get(url: url);
      expect(client.method, 'get');
      expect(client.callsCount, 1);
    });

    test('should request with correct url', () async {
      await sut.get(url: url);
      expect(client.url, url);
    });

    test('should request with default headers', () async {
      await sut.get(url: url);
      expect(client.headers?['content-type'], 'application/json');
      expect(client.headers?['accept'], 'application/json');
    });

    test('should append headers', () async {
      await sut.get(url: url, headers: { 'h1': 'value1', 'h2': 'value2' });
      expect(client.headers?['content-type'], 'application/json');
      expect(client.headers?['accept'], 'application/json');
      expect(client.headers?['h1'], 'value1');
      expect(client.headers?['h2'], 'value2');
    });

    test('should request with correct params', () async {
      url = 'http://anyurl.com/:p1/:p2';
      await sut.get(url: url, params: { 'p1': 'v1', 'p2': 'v2' });
      expect(client.url, 'http://anyurl.com/v1/v2');
    });

    test('should request with optional param', () async {
      url = 'http://anyurl.com/:p1/:p2';
      await sut.get(url: url, params: { 'p1': 'v1', 'p2': null });
      expect(client.url, 'http://anyurl.com/v1');
    });

    test('should request with invalid params', () async {
      url = 'http://anyurl.com/:p1/:p2';
      await sut.get(url: url, params: { 'p3': 'v3' });
      expect(client.url, 'http://anyurl.com/:p1/:p2');
    });
  });
}
