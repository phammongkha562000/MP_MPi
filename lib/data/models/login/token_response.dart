class TokenResponse {
  TokenResponse(
      {this.accessToken,
      this.refreshToken,
      this.userName,
      this.asEmployeeId,
      this.asUseDefaultPass,
      this.asVersion,
      this.asIgnoreCheckLocation});

  String? accessToken;
  String? refreshToken;
  String? userName;
  String? asEmployeeId;
  String? asUseDefaultPass;
  String? asVersion;
  String? asIgnoreCheckLocation;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      userName: json["userName"],
      asEmployeeId: json["as:employee_id"],
      asUseDefaultPass: json["as:use_default_pass"],
      asVersion: json["as:version"], //17/11/23
      asIgnoreCheckLocation: json["as:ignore_check_location"]); //21/11
}
