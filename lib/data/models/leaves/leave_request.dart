class LeaveRequest {
  LeaveRequest(
      {this.leaveType,
      this.status,
      this.submitDateF,
      this.submitDateT,
      this.userId,
      this.pageNumber,
      this.rowNumber});

  String? leaveType;
  String? status;
  String? submitDateF;
  String? submitDateT;
  int? userId;
  int? pageNumber;
  int? rowNumber;

  Map<String, dynamic> toJson() => {
        "LeaveType": leaveType,
        "Status": status,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "UserId": userId,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
