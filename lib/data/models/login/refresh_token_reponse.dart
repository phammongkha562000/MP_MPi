class RefreshTokenResponse {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  String? asSystemId;
  String? userName;
  String? asEmployeeId;
  String? asUseDefaultPass;
  String? asVersion;
  String? asIgnoreCheckLocation;
  String? issued;
  String? expires;

  RefreshTokenResponse(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.refreshToken,
      this.asSystemId,
      this.userName,
      this.asEmployeeId,
      this.asUseDefaultPass,
      this.asVersion,
      this.asIgnoreCheckLocation,
      this.issued,
      this.expires});

  RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    asSystemId = json['as:system_id'];
    userName = json['userName'];
    asEmployeeId = json['as:employee_id'];
    asUseDefaultPass = json['as:use_default_pass'];
    asVersion = json['as:version'];
    asIgnoreCheckLocation = json['as:ignore_check_location'];
    issued = json['.issued'];
    expires = json['.expires'];
  }
}
