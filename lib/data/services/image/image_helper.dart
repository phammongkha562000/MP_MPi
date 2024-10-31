import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../businesses_logics/config/server_config.dart';
import '../../data.dart';

class ImageHelper {
  static Future<bool> isImage({
    required String url,
    required String sv,
  }) async {
    try {
      ServerInfo serverInfo = await ServerConfig.getAddressServerInfo(sv);
      String startUrl = serverInfo.serverUpload.toString();
      var newUrl = url.replaceAll("\\", "/");
      final dio = Dio();
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      final response = await dio.head(
        "$startUrl$newUrl",
      );

      final headers = response.headers.map;
      final contentType = headers['content-type']?.first;
      if (contentType?.startsWith('image/') == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // static Future<String> setAvatar({
  //   required String linkAvt,
  //   required String sv,
  // }) async {
  //   String avt = "";
  //   if (linkAvt == "null") {
  //     return "null";
  //   } else {
  //     var newUrl = linkAvt.replaceAll("\\", "/");
  //     ServerInfo serverInfo = await ServerConfig.getAddressServerInfo(sv);
  //     String startUrl = serverInfo.serverUpload.toString();
  //     avt = "$startUrl$newUrl";
  //     return avt;
  //   }
  // }

  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<File?> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
