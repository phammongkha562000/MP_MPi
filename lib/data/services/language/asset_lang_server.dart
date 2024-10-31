import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../businesses_logics/config/server_config.dart';
import '../../data.dart';

class DioAssetLoader extends AssetLoader {
  const DioAssetLoader();

  @override
  Future<Map<String, dynamic>> load(
    String path,
    Locale locale,
  ) async {
    try {
      if (globalApp.isLogin == false) {
        log("GET LANG BY ASSETS");
        var driverLanguage =
            await getDefaultLanguageFromAssets(locale.languageCode);
        return driverLanguage;
      }
      final sharedPref = await SharedPreferencesService.instance;
      final serverMode = sharedPref.serverMode;
      if (serverMode != null && serverMode != '') {
        ServerInfo serverInfo =
            await ServerConfig.getAddressServerInfo(serverMode);

        String urlServer = serverInfo.sso.toString();
        var url =
            "$urlServer/api/mpi/commonservice/resources/${locale.languageCode.toUpperCase()}";

        BaseOptions options = BaseOptions(
          baseUrl: url,
          method: "GET",
        );

        Dio dio = Dio(options);

        var response = await dio.get(url);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonData = response.data["payload"];
          log(jsonData.toString());
          return jsonData;
        } else {
          log("GET LANG BY ASSETS");
          var driverLanguage =
              await getDefaultLanguageFromAssets(locale.languageCode);
          return driverLanguage;
        }
      } else {
        log("GET LANG BY ASSETS");
        var driverLanguage =
            await getDefaultLanguageFromAssets(locale.languageCode);
        return driverLanguage;
      }
    } catch (e) {
      log("GET LANG BY ASSETS");
      var driverLanguage =
          await getDefaultLanguageFromAssets(locale.languageCode);
      return driverLanguage;
    }
  }

  Future getDefaultLanguageFromAssets(String locale) async {
    try {
      final assetPath = 'assets/lang/$locale.json';
      final languageString = await rootBundle.loadString(assetPath);
      var languageJson = jsonDecode(languageString);
      return languageJson;
    } catch (e) {
      log('Error loading default language asset: $e');
      return null;
    }
  }
}
