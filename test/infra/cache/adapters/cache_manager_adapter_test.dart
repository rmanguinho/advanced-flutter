import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';

final class CacheManagerAdapter {
  final BaseCacheManager client;

  const CacheManagerAdapter({
    required this.client
  });

  Future<void> get({ required String key }) async {
    await client.getFileFromCache(key);
  }
}

final class CacheManagerSpy implements BaseCacheManager {
  int getFileFromCacheCallsCount = 0;
  String? key;

  @override
  Future<void> dispose() => throw UnimplementedError();

  @override
  Future<FileInfo> downloadFile(String url, {String? key, Map<String, String>? authHeaders, bool force = false}) => throw UnimplementedError();

  @override
  Future<void> emptyCache() {
    throw UnimplementedError();
  }

  @override
  Stream<FileInfo> getFile(String url, {String? key, Map<String, String>? headers}) {
    // TODO: implement getFile
    throw UnimplementedError();
  }

  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async {
    getFileFromCacheCallsCount++;
    this.key = key;
    return null;
  }

  @override
  Future<FileInfo?> getFileFromMemory(String key) {
    // TODO: implement getFileFromMemory
    throw UnimplementedError();
  }

  @override
  Stream<FileResponse> getFileStream(String url, {String? key, Map<String, String>? headers, bool? withProgress}) {
    // TODO: implement getFileStream
    throw UnimplementedError();
  }

  @override
  Future<File> getSingleFile(String url, {String? key, Map<String, String>? headers}) {
    // TODO: implement getSingleFile
    throw UnimplementedError();
  }

  @override
  Future<File> putFile(String url, Uint8List fileBytes, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) {
    // TODO: implement putFile
    throw UnimplementedError();
  }

  @override
  Future<File> putFileStream(String url, Stream<List<int>> source, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) {
    // TODO: implement putFileStream
    throw UnimplementedError();
  }

  @override
  Future<void> removeFile(String key) {
    // TODO: implement removeFile
    throw UnimplementedError();
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
}
