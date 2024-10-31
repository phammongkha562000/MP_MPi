class MenuRequest {
  MenuRequest({
    required this.userId,
    required this.systemId,
    required this.platformId,
    required this.subsidiaryId,
  });

  String userId;
  String systemId;
  String platformId;
  String subsidiaryId;

  factory MenuRequest.fromJson(Map<String, dynamic> json) => MenuRequest(
        userId: json["UserID"],
        systemId: json["SystemId"],
        platformId: json["PlatformId"],
        subsidiaryId: json["SubsidiaryId"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "SystemId": systemId,
        "PlatformId": platformId,
        "SubsidiaryId": subsidiaryId,
      };
}
