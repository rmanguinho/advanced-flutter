import 'dart:convert';

import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../mocks/cache_manager_spy.dart';

final class CacheManagerAdapter implements CacheGetClient {
  final BaseCacheManager client;

  const CacheManagerAdapter({
    required this.client
  });

  @override
  Future<dynamic> get({ required String key }) async {
    try {
      final info = await client.getFileFromCache(key);
      if (info?.validTill.isBefore(DateTime.now()) != false || !await info!.file.exists()) return null;
      final data = await info.file.readAsString();
      return jsonDecode(data);
    } catch (err) {
      return null;
    }
  }
}

void main() {
  late String key;
  late CacheManagerSpy client;
  late CacheManagerAdapter sut;

  setUp(() {
    key = anyString();
    client = CacheManagerSpy();
    sut = CacheManagerAdapter(client: client);
  });

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
}
