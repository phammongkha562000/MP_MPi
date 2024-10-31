class ItServiceReplyRequest {
  ItServiceReplyRequest({
    required this.createuser,
    required this.assignTo,
    required this.details,
    required this.iSrNo,
    required this.sRStatus,
  });

  String createuser;
  String assignTo;
  String details;
  String iSrNo;
  String sRStatus;

  Map<String, dynamic> toJson() => {
        "createuser": createuser,
        "assignTo": assignTo,
        "details": details,
        "iSRNo": iSrNo,
        "sRStatus": sRStatus,
      };
}
