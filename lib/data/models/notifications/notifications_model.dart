class NotificationsModel {
  final String userId;
  final String userName;
  final String token;
  final String platform;
  final int status;
  final String? userVersion;

  NotificationsModel({
    required this.userId,
    required this.userName,
    required this.platform,
    required this.token,
    required this.status,
    this.userVersion,
  });

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "UserName": userName,
        "Platform": platform,
        "Token": token,
        "Status": status,
        "UserVersion": userVersion
      };
}
