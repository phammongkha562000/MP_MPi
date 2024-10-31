import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../data.dart';

Future<bool> isDownloadFile({
  required String pathNew,
  required String fileName,
}) async {
  try {
    void showDownloadProgress(received, total) {
      if (total != -1) {
        log((received / total * 100).toStringAsFixed(0) + "%");
      }
    }

    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS

    if (directory != null) {
      String documentPath = '${directory.path}/document';
      Directory bigDir = Directory(documentPath);
      if (!await bigDir.exists()) {
        await bigDir.create();
      }
      final pathFileClient = '$documentPath/$fileName';

      final dio = Dio();

      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final response = await dio.get(
        pathNew,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          // contentType: "application/pdf",
        ),
      );
      final file = File(pathFileClient);
      await file.writeAsBytes(response.data, flush: true);
      await file.exists();

      return true;
    } else {
      return false;
    }
  } catch (e) {
    log("ERR: $e");
    return false;
  }
}

Future<String> getPathFile({
  required String fileName,
}) async {
  Directory? directory = Platform.isAndroid
      ? await getExternalStorageDirectory() //FOR ANDROID
      : await getApplicationSupportDirectory(); //FOR iOS

  return '${directory!.path}/document/$fileName';
}

String checkFileType(String fileString) {
  // Extract the file extension
  String fileExtension = fileString.split('.').last;

  Map<String, String> fileTypeMap = {
    'pdf': FileCheck.pdf,
    'xlsx': FileCheck.xlsx,
    'xls': FileCheck.xlsx,
    'docx': FileCheck.docx,
    'doc': FileCheck.docx,
  };
  String fileType = fileTypeMap[fileExtension] ?? FileCheck.unknown;

  return fileType;
}
