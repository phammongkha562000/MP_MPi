class GlobalServer {
  String? deviceId;
  get getDeviceId => deviceId;
  set setDeviceId(value) => deviceId = value;

  String? token;
  get getToken => token;
  set setToken(value) => token = value;

  String? refreshToken;
  get getRefreshToken => refreshToken;
  set setRefreshToken(value) => refreshToken = value;

  bool? tokenExpires;
  bool? get getTokenExpires => tokenExpires;
  set setTokenExpires(bool? value) => tokenExpires = value;
}

GlobalServer globalServer = GlobalServer();
