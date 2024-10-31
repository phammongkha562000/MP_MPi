class NotificationDeleteRequest {
  final String strReqIds;
  final String strSoueceType;
  final String notifyType;
  final bool isDelAll;

  NotificationDeleteRequest({
    required this.strReqIds,
    required this.strSoueceType,
    required this.notifyType,
    required this.isDelAll,
  });

  Map<String, dynamic> toJson() => {
        "strReqIds": strReqIds,
        "strSoueceType": strSoueceType,
        "notifyType": notifyType,
        "IsDelAll": isDelAll,
      };
}
