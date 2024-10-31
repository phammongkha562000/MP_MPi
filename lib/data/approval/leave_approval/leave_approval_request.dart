class LeaveApprovalRequest {
  String? leaveType;
  final String submitDateF;
  final String submitDateT;
  String? status;
  final int userId;
  final int pageNumber;
  final int rowNumber;

  LeaveApprovalRequest(
      {this.leaveType,
      required this.submitDateF,
      required this.submitDateT,
      this.status,
      required this.userId,
      required this.pageNumber,
      required this.rowNumber});

  Map<String, dynamic> toJson() => {
        "LeaveType": leaveType,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "Status": status,
        "UserId": userId,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
