import 'dart:typed_data';

import 'package:file/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'file_spy.dart';

final class CacheManagerSpy implements BaseCacheManager {
  int getFileFromCacheCallsCount = 0;
  int putFileCallsCount = 0;
  String? key;
  String? fileExtension;
  Uint8List? fileBytes;
  FileSpy file = FileSpy();
  bool _isFileInfoEmpty = false;
  DateTime _validTill = DateTime.now().add(const Duration(seconds: 2));
  Error? _getFileFromCachError;

  void simulateEmptyFileInfo() => _isFileInfoEmpty = true;
  void simulateCacheOld() => _validTill = DateTime.now().subtract(const Duration(seconds: 2));
  void simulateGetFileFromCacheError() => _getFileFromCachError = Error();

  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async {
    getFileFromCacheCallsCount++;
    this.key = key;
    if (_getFileFromCachError != null) throw _getFileFromCachError!;
    return _isFileInfoEmpty ? null : FileInfo(file, FileSource.Cache, _validTill, '');
  }

  @override
  Future<File> putFile(String url, Uint8List fileBytes, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) async {
    putFileCallsCount++;
    this.key = url;
    this.fileExtension = fileExtension;
    this.fileBytes = fileBytes;
    return file;
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
  Future<File> putFileStream(String url, Stream<List<int>> source, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) => throw UnimplementedError();

  @override
  Future<void> removeFile(String key) => throw UnimplementedError();
}
