import 'dart:convert';
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

  Future<dynamic> get({ required String key }) async {
    final info = await client.getFileFromCache(key);
    if (info?.validTill.isBefore(DateTime.now()) != false || !await info!.file.exists()) return null;
    final data = await info.file.readAsString();
    try {
      return jsonDecode(data);
    } catch (err) {
      return null;
    }
  }
}

final class FileSpy implements File {
  int existsCallsCount = 0;
  int readAsStringCallsCount = 0;
  bool _fileExists = true;
  String _response = '{}';

  void simulateFileEmpty() => _fileExists = false;
  void simulateInvalidResponse() => _response = 'invalid_json';
  void simulateResponse(String response) => _response = response;

  @override
  Future<bool> exists() async {
    existsCallsCount++;
    return _fileExists;
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) async {
    readAsStringCallsCount++;
    return _response;
  }

  @override
  File get absolute => throw UnimplementedError();

  @override
  String get basename => throw UnimplementedError();

  @override
  Future<File> copy(String newPath) => throw UnimplementedError();

  @override
  File copySync(String newPath) => throw UnimplementedError();

  @override
  Future<File> create({bool recursive = false, bool exclusive = false}) => throw UnimplementedError();

  @override
  void createSync({bool recursive = false, bool exclusive = false}) => throw UnimplementedError();

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) => throw UnimplementedError();

  @override
  void deleteSync({bool recursive = false}) => throw UnimplementedError();

  @override
  String get dirname => throw UnimplementedError();

  @override
  bool existsSync() => throw UnimplementedError();

  @override
  FileSystem get fileSystem => throw UnimplementedError();

  @override
  bool get isAbsolute => throw UnimplementedError();

  @override
  Future<DateTime> lastAccessed() => throw UnimplementedError();

  @override
  DateTime lastAccessedSync() => throw UnimplementedError();

  @override
  Future<DateTime> lastModified() => throw UnimplementedError();

  @override
  DateTime lastModifiedSync() => throw UnimplementedError();

  @override
  Future<int> length() => throw UnimplementedError();

  @override
  int lengthSync() => throw UnimplementedError();

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) => throw UnimplementedError();

  @override
  Stream<List<int>> openRead([int? start, int? end]) => throw UnimplementedError();

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) => throw UnimplementedError();

  @override
  IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Directory get parent => throw UnimplementedError();

  @override
  String get path => throw UnimplementedError();

  @override
  Future<Uint8List> readAsBytes() => throw UnimplementedError();

  @override
  Uint8List readAsBytesSync() => throw UnimplementedError();

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  String readAsStringSync({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Future<File> rename(String newPath) => throw UnimplementedError();

  @override
  File renameSync(String newPath) => throw UnimplementedError();

  @override
  Future<String> resolveSymbolicLinks() => throw UnimplementedError();

  @override
  String resolveSymbolicLinksSync() => throw UnimplementedError();

  @override
  Future setLastAccessed(DateTime time) => throw UnimplementedError();

  @override
  void setLastAccessedSync(DateTime time) => throw UnimplementedError();

  @override
  Future setLastModified(DateTime time) => throw UnimplementedError();

  @override
  void setLastModifiedSync(DateTime time) => throw UnimplementedError();

  @override
  Future<FileStat> stat() => throw UnimplementedError();

  @override
  FileStat statSync() => throw UnimplementedError();

  @override
  Uri get uri => throw UnimplementedError();

  @override
  Stream<FileSystemEvent> watch({int events = FileSystemEvent.all, bool recursive = false}) => throw UnimplementedError();

  @override
  Future<File> writeAsBytes(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) => throw UnimplementedError();

  @override
  void writeAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) => throw UnimplementedError();

  @override
  Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) => throw UnimplementedError();

  @override
  void writeAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) => throw UnimplementedError();
}

final class CacheManagerSpy implements BaseCacheManager {
  int getFileFromCacheCallsCount = 0;
  String? key;
  FileSpy file = FileSpy();
  bool _isFileInfoEmpty = false;
  DateTime _validTill = DateTime.now().add(const Duration(seconds: 2));

  void simulateEmptyFileInfo() => _isFileInfoEmpty = true;
  void simulateCacheOld() => _validTill = DateTime.now().subtract(const Duration(seconds: 2));

  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async {
    getFileFromCacheCallsCount++;
    this.key = key;
    return _isFileInfoEmpty ? null : FileInfo(file, FileSource.Cache, _validTill, '');
  }

  @override
  Future<void> dispose() => throw UnimplementedError();

  @override
  Future<FileInfo> downloadFile(String url, {String? key, Map<String, String>? authHeaders, bool force = false}) => throw UnimplementedError();

  @override
  Future<void> emptyCache() => throw UnimplementedError();

  @override
  Stream<FileInfo> getFile(String url, {String? key, Map<String, String>? headers}) => throw UnimplementedError();

  @override
  Future<FileInfo?> getFileFromMemory(String key) => throw UnimplementedError();

  @override
  Stream<FileResponse> getFileStream(String url, {String? key, Map<String, String>? headers, bool? withProgress}) => throw UnimplementedError();

  @override
  Future<File> getSingleFile(String url, {String? key, Map<String, String>? headers}) => throw UnimplementedError();

  @override
  Future<File> putFile(String url, Uint8List fileBytes, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) => throw UnimplementedError();

  @override
  Future<File> putFileStream(String url, Stream<List<int>> source, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) => throw UnimplementedError();

  @override
  Future<void> removeFile(String key) => throw UnimplementedError();
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
}
