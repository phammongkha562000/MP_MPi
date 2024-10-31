class LeaveApprovalRequest {
  String? leaveType;
  final String submitDateF;
  final String submitDateT;
  String? status;
  final int userId;

  LeaveApprovalRequest(
      {this.leaveType,
      required this.submitDateF,
      required this.submitDateT,
      this.status,
      required this.userId});

  Map<String, dynamic> toJson() => {
        "LeaveType": leaveType,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "Status": status,
        "UserId": userId
      };
}
