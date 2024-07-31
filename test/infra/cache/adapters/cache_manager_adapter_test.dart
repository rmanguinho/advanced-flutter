import 'dart:convert';

import 'package:advanced_flutter/infra/cache/adapters/cache_manager_adapter.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../mocks/cache_manager_spy.dart';

void main() {
  late String key;
  late CacheManagerSpy client;
  late CacheManagerAdapter sut;

  setUp(() {
    key = anyString();
    client = CacheManagerSpy();
    sut = CacheManagerAdapter(client: client);
  });

  group('get', () {
    test('should call getFileFromCache with correct input', () async {
      await sut.get(key: key);
      expect(client.key, key);
      expect(client.getFileFromCacheCallsCount, 1);
    });

    test('should return null if FileInfo is empty', () async {
      client.simulateEmptyFileInfo();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });

    test('should return null if cache is old', () async {
      client.simulateCacheOld();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });

    test('should call file.exists only once', () async {
      await sut.get(key: key);
      expect(client.file.existsCallsCount, 1);
    });

    test('should return null if file is empty', () async {
      client.file.simulateFileEmpty();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });

    test('should call file.readAsString only once', () async {
      await sut.get(key: key);
      expect(client.file.readAsStringCallsCount, 1);
    });

    test('should return null if cache is invalid', () async {
      client.file.simulateInvalidResponse();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });

    test('should return json if cache is valid', () async {
      client.file.simulateResponse('''
        {
          "key1": "value1",
          "key2": "value2"
        }
      ''');
      final json = await sut.get(key: key);
      expect(json['key1'], 'value1');
      expect(json['key2'], 'value2');
    });

    test('should return null if file.readAsString fails', () async {
      client.file.simulateReadAsStringError();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });

    test('should return null if file.exists fails', () async {
      client.file.simulateExistsError();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });

    test('should return null if getFileFromCache fails', () async {
      client.simulateGetFileFromCacheError();
      final json = await sut.get(key: key);
      expect(json, isNull);
    });
  });

  group('save', () {
    late Map value;

    setUp(() {
      value = {
        'key1': anyString(),
        'key2': anyIsoDate(),
        'key3': anyBool(),
        'key4': anyInt()
      };
    });

    test('should call putFile with correct input', () async {
      await sut.save(key: key, value: value);
      expect(client.key, key);
      expect(client.fileExtension, 'json');
      expect(client.fileBytesDecoded, value);
      expect(client.putFileCallsCount, 1);
    });
  });
}
