class NotificationUpdateRequest {
  final String username;
  final String reqIds;
  final String finalStatusMessage;

  NotificationUpdateRequest(
      {required this.username,
      required this.reqIds,
      required this.finalStatusMessage});

  Map<String, dynamic> toJson() => {
        "Username": username,
        "ReqIds": reqIds,
        "FinalStatusMessage": finalStatusMessage
      };
}
