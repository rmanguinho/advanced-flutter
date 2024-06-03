import 'dart:convert';

import 'package:advanced_flutter/domain/entities/domain_error.dart';
import 'package:advanced_flutter/infra/types/json.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../../../helpers/fakes.dart';
import 'client_spy.dart';

class HttpClient {
  final Client client;

  HttpClient({
    required this.client
  });

  Future<T> get<T>({ required String url, Map<String, String>? headers, Map<String, String?>? params, Map<String, String>? queryString }) async {
    final allHeaders = (headers ?? {})..addAll({ 'content-type': 'application/json', 'accept': 'application/json' });
    final uri = _buildUri(url: url, params: params, queryString: queryString);
    final response = await client.get(uri, headers: allHeaders);
    switch (response.statusCode) {
      case 200: {
        final data = jsonDecode(response.body);
        return (T == JsonArr) ? data.map<Json>((e) => e as Json).toList() : data;
      }
      case 401: throw DomainError.sessionExpired;
      default: throw DomainError.unexpected;
    }
  }

  Uri _buildUri({ required String url, Map<String, String?>? params, Map<String, String>? queryString }) {
    url = params?.keys.fold(url, (result, key) => result.replaceFirst(':$key', params[key] ?? '')).removeSuffix('/') ?? url;
    url = queryString?.keys.fold('$url?', (result, key) => '$result$key=${queryString[key]}&').removeSuffix('&') ?? url;
    return Uri.parse(url);
  }
}

void main() {
  late ClientSpy client;
  late HttpClient sut;
  late String url;

  setUp(() {
    client = ClientSpy();
    client.responseJson = '''
      {
        "key1": "value1",
        "key2": "value2"
      }
    ''';
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

    test('should request with correct queryStrings', () async {
      await sut.get(url: url, queryString: { 'q1': 'v1', 'q2': 'v2' });
      expect(client.url, '$url?q1=v1&q2=v2');
    });

    test('should request with correct queryStrings and params', () async {
      url = 'http://anyurl.com/:p3/:p4';
      await sut.get(url: url, queryString: { 'q1': 'v1', 'q2': 'v2' }, params: { 'p3': 'v3', 'p4': 'v4' });
      expect(client.url, 'http://anyurl.com/v3/v4?q1=v1&q2=v2');
    });

    test('should throw UnexpectedError on 400', () async {
      client.simulateBadRequestError();
      final future = sut.get(url: url);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw SessionExpiredError on 401', () async {
      client.simulateUnauthorizedError();
      final future = sut.get(url: url);
      expect(future, throwsA(DomainError.sessionExpired));
    });

    test('should throw UnexpectedError on 403', () async {
      client.simulateForbiddenError();
      final future = sut.get(url: url);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError on 404', () async {
      client.simulateNotFoundError();
      final future = sut.get(url: url);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError on 500', () async {
      client.simulateServerError();
      final future = sut.get(url: url);
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should return a Map', () async {
      final data = await sut.get<Json>(url: url);
      expect(data['key1'], 'value1');
      expect(data['key2'], 'value2');
    });

    test('should return a List', () async {
      client.responseJson = '''
        [{
          "key": "value1"
        }, {
          "key": "value2"
        }]
      ''';
      final data = await sut.get<JsonArr>(url: url);
      expect(data[0]['key'], 'value1');
      expect(data[1]['key'], 'value2');
    });
  });
}
