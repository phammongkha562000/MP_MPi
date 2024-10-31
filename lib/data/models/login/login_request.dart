class LoginRequest {
  final String username;
  final String password;
  final String granttype;
  final String clientid;
  LoginRequest(
      {required this.username,
      required this.password,
      required this.granttype,
      required this.clientid});

  factory LoginRequest.fromMap(Map<String, dynamic> map) {
    return LoginRequest(
        username: map['username'] as String,
        password: map['password'] as String,
        granttype: map['grant_type'] as String,
        clientid: map['client_id'] as String);
  }
}
