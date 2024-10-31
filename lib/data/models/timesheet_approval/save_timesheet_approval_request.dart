class SaveTimesheetApprovalRequest {
  final int tsId;
  final String updateUser;
  final String approveType;
  final String approveComment;

  SaveTimesheetApprovalRequest(
      {required this.tsId,
      required this.updateUser,
      required this.approveType,
      required this.approveComment});

  factory SaveTimesheetApprovalRequest.fromJson(Map<String, dynamic> json) =>
      SaveTimesheetApprovalRequest(
          tsId: json["tsId"],
          updateUser: json["updateUser"],
          approveType: json["approveType"],
          approveComment: json["approveComment"]);

  Map<String, dynamic> toJson() => {
        "tsId": tsId,
        "updateUser": updateUser,
        "approveType": approveType,
        "approveComment": approveComment
      };
}
