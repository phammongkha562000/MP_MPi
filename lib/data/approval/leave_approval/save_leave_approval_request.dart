class SaveLeaveApprovalRequest {
  final String comment;
  final String approvalType;
  final String existedUserId;
  final int userId;
  final String hLvNo;

  SaveLeaveApprovalRequest(
      {required this.comment,
      required this.approvalType,
      required this.existedUserId,
      required this.userId,
      required this.hLvNo});

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "ApprovalType": approvalType,
        "existedUserId": existedUserId,
        "Userid": userId,
        "hLvNo": hLvNo
      };
}
