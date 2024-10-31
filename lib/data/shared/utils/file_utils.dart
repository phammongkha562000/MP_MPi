// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> createFolderInAppDocDir(String folderName) async {
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${await _localPath}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<String> localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName').path;
  }

  static Future<bool> fileExist({required String fileName}) async {
    final file = await _localFile(fileName);

    return file.existsSync();
  }

  static Future<String> readFile({required String fileName}) async {
    try {
      final file = await _localFile(fileName);
      return await file.readAsString();
    } catch (e) {
      rethrow;
    }
  }

  static Future<File> writeFile(
      {required String fileName, required String contents}) async {
    final file = await _localFile(fileName);
    return file.writeAsString(contents);
  }

  static Future<void> deleteFile({required String fileName}) async {
    try {
      final file = await _localFile(fileName);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteFileInPath({required String path}) async {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      rethrow;
    }
  }

  static String convertMiliSecondToDate(String date) {
    String strDate;
    if (date.isEmpty) {
      strDate = "";
    } else {
      int miliseconds =
          int.parse(date.replaceAll('/Date(', '').replaceAll('+0700)/', ''));
      strDate =
          DateTime.fromMicrosecondsSinceEpoch(miliseconds * 1000).toString();
    }
    return strDate;
  }
}

Future<String> saveImage(BuildContext context, Image image) {
  final completer = Completer<String>();

  image.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo imageInfo, bool _) async {
    final byteData =
        await imageInfo.image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final fileName = pngBytes.hashCode;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);
    completer.complete(filePath);
  }));

  return completer.future;
}
