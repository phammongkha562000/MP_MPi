// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();

// ?=================================================
  static const String sso = "server_sso";
  static const String address = "server_address";
  static const String notification = "server_notification";
  static const String api = "server_api";
  static const String inspection = "server_inspection";
  static const String hub = "server_hub";
  static const String serverMode = "server_mode";

  // ?=================================================
  static const String refresh_token = 'refresh_token';
  static const String languageCode = 'language_code';
  // ?=================================================
  static const String lat = "location_lat";
  static const String lon = "location_lon";
  static const String ip = "ip";
  static const String logz = "logz";
  // ?=================================================
  static const String remember = 'remember';
  static const String systemId = "systemId";
  static const String subsidiaryName = "subsidiary_name";

  //login
  static const String username = 'username';
  static const String password = "password";

  // * Biometrics
  static const String isAllowBiometrics = "is_allow_biometrics";
  static const String isBiometrics = "is_biometrics";

//19/06/2023
  static const String loginName = "login_name";
  static const String subsidiaryId = "subsidiaryId";

  //04/06/2024
  static const String isCheckVersion = "is_check_version";

  static List<String> listKey = [
    sso,
    address,
    notification,
    api,
    inspection,
    hub,
    refresh_token,
    languageCode,
    lat,
    lon,
    ip,
    logz,
    subsidiaryId,
    subsidiaryName,
    systemId,
    loginName,
    subsidiaryId,
    isCheckVersion
  ];
}

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _instance ??= SharedPreferencesService._internal();
  }

  static Future<void> reload() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.reload();
  }

  Future<void> setServerSSO(String serverCode) async =>
      await _preferences!.setString(SharedPrefKeys.sso, serverCode);
  String? get serverSSO => _preferences!.getString(SharedPrefKeys.sso);

  // ? address
  Future<void> setServerAddress(String serverAddress) async =>
      await _preferences!.setString(SharedPrefKeys.address, serverAddress);
  String? get serverAddress => _preferences!.getString(SharedPrefKeys.address);

  // ? notification
  Future<void> setServerNotification(String notificationServerName) async =>
      await _preferences!
          .setString(SharedPrefKeys.notification, notificationServerName);
  String? get serverNotification =>
      _preferences!.getString(SharedPrefKeys.notification);

// ? api
  Future<void> setServerAPI(String api) async =>
      await _preferences!.setString(SharedPrefKeys.api, api);
  String? get serverAPI => _preferences!.getString(SharedPrefKeys.api);
// ? hub
  Future<void> setServerHub(String serverHub) async =>
      await _preferences!.setString(SharedPrefKeys.hub, serverHub);
  String? get serverHub => _preferences!.getString(SharedPrefKeys.hub);

// ? inspection
  Future<void> setServerInspection(String serverInspection) async =>
      await _preferences!
          .setString(SharedPrefKeys.inspection, serverInspection);
  String? get serverInspection =>
      _preferences!.getString(SharedPrefKeys.inspection);
  // ? mode
  Future<void> setServerMode(String serverMode) async =>
      await _preferences!.setString(SharedPrefKeys.serverMode, serverMode);
  String? get serverMode => _preferences!.getString(SharedPrefKeys.serverMode);

  // *=============Refresh TOken ==============================================
  Future<void> setRefreshToken(String refreshToken) async =>
      await _preferences!.setString(SharedPrefKeys.refresh_token, refreshToken);
  String? get refreshToken =>
      _preferences!.getString(SharedPrefKeys.refresh_token);

  Future<void> setLanguage(String languageCode) async =>
      await _preferences!.setString(SharedPrefKeys.languageCode, languageCode);

  String? get language => _preferences!.getString(SharedPrefKeys.languageCode);

  // *==================LAT======LON===========================================
  // ? lat location
  Future<void> setLatLocation(String lat) async =>
      await _preferences!.setString(SharedPrefKeys.lat, lat);
  String? get latLocation => _preferences!.getString(SharedPrefKeys.lat);
  // ? lon location
  Future<void> setLonLocation(String lon) async =>
      await _preferences!.setString(SharedPrefKeys.lon, lon);
  String? get lonLocation => _preferences!.getString(SharedPrefKeys.lon);
  // *=========================================================================

  // ? remember
  Future<void> setRemember(bool remember) async =>
      await _preferences!.setBool(SharedPrefKeys.remember, remember);

  bool? get remember => _preferences!.getBool(SharedPrefKeys.remember);
  // ? systemId
  Future<void> setSystemId(String systemId) async =>
      await _preferences!.setString(SharedPrefKeys.systemId, systemId);

  String? get systemId => _preferences!.getString(SharedPrefKeys.systemId);
  // ? subsidiaryId
  Future<void> setSubsidiaryId(String subsidiaryId) async =>
      await _preferences!.setString(SharedPrefKeys.subsidiaryId, subsidiaryId);

  String? get subsidiaryId =>
      _preferences!.getString(SharedPrefKeys.subsidiaryId);
  // ?subsidiary name
  Future<void> setSubsidiaryName(String subsidiaryName) async =>
      await _preferences!
          .setString(SharedPrefKeys.subsidiaryName, subsidiaryName);
  String? get subsidiaryName =>
      _preferences!.getString(SharedPrefKeys.subsidiaryName);

  Future<void> setEnableLogz(bool logz) async =>
      await _preferences!.setBool(SharedPrefKeys.logz, logz);
  bool? get enableLogz => _preferences!.getBool(SharedPrefKeys.logz);

//username
  Future<void> setUsername(String username) async =>
      await _preferences!.setString(SharedPrefKeys.username, username);
  String? get username => _preferences!.getString(SharedPrefKeys.username);

//password
  Future<void> setPassword(String password) async =>
      await _preferences!.setString(SharedPrefKeys.password, password);
  String? get password => _preferences!.getString(SharedPrefKeys.password);

// *===========================================================================
// *===========================================================================

  Future<void> remove(String key) async => await _preferences!.remove(key);

// *===========================================================================
// *===========================================================================
//* Biometrics
  Future<void> setIsAllowBiometrics(bool isAllowBiometrics) async =>
      await _preferences!
          .setBool(SharedPrefKeys.isAllowBiometrics, isAllowBiometrics);
  bool? get isAllowBiometrics =>
      _preferences!.getBool(SharedPrefKeys.isAllowBiometrics);
  Future<void> setIsBiometrics(bool isBiometrics) async =>
      await _preferences!.setBool(SharedPrefKeys.isBiometrics, isBiometrics);
  bool? get isBiometrics => _preferences!.getBool(SharedPrefKeys.isBiometrics);

//19/06/2023
  Future<void> setLoginName(String loginName) async =>
      await _preferences!.setString(SharedPrefKeys.loginName, loginName);
  String? get loginName => _preferences!.getString(SharedPrefKeys.loginName);

  //04/06/2024
  Future<void> setIsCheckVersion(bool isCheckVersion) async =>
      await _preferences!
          .setBool(SharedPrefKeys.isCheckVersion, isCheckVersion);
  bool? get isCheckVersion =>
      _preferences!.getBool(SharedPrefKeys.isCheckVersion);
}
