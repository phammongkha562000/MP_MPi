class RefreshTokenRequest {
  String? grantType;
  String? refreshToken;
  String? clienId;

  RefreshTokenRequest({this.grantType, this.refreshToken, this.clienId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grant_type'] = grantType;
    data['refresh_token'] = refreshToken;
    data['client_id'] = clienId;
    return data;
  }
}
