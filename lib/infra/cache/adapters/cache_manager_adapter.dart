import 'dart:convert';

import 'package:advanced_flutter/infra/cache/clients/cache_get_client.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
