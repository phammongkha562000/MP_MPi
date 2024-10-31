//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

// ignore: implementation_imports
import 'package:device_info_plus/src/device_info_plus_web.dart';
import 'package:flutter_native_splash/flutter_native_splash_web.dart';
// import 'package:location_web/location_web.dart';
// ignore: implementation_imports
import 'package:package_info_plus/src/package_info_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  DeviceInfoPlusWebPlugin.registerWith(registrar);
  FlutterNativeSplashWeb.registerWith(registrar);
  // LocationWebPlugin.registerWith(registrar);
  PackageInfoPlusWebPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
