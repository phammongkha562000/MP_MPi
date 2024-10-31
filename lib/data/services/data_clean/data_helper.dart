import 'dart:developer';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class DataHelper {
  static Future<void> cleanAll() async {
    try {
      var size = await getCacheSize();
      log("SIZE: $size");
      if (size > 0) {
        // clearCache();
        clearTempDirectory();
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }

  static Future<String> getCacheDirectory() async {
    final cacheDir = Platform.isIOS
        ? "${(await getTemporaryDirectory()).path}/../Library/Caches"
        : (await getApplicationSupportDirectory()).path;

    return cacheDir;
  }

  static Future<void> clearTempDirectory() async {
    try {
      final tempDir = await getTemporaryDirectory();
      tempDir.delete(recursive: true);
    } catch (e) {
      throw MissingPlatformDirectoryException(
          'Unable to get temporary directory: $e');
    }
  }

  static Future<int> getCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      int size = 0;
      await for (FileSystemEntity entity
          in cacheDir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
      return size;
    } catch (e) {
      log('Error getting cache size: $e');
      return 0;
    }
  }
}
