class TimesheetApprovalRequest {
  final int skipRecord;
  final String submitDateF;
  final String submitDateT;
  final int takeRecord;
  final String employeeId;
  final String status;
  final String userId;
  final int pageNumber;
  final int rowNumber;

  TimesheetApprovalRequest(
      {required this.skipRecord,
      required this.submitDateF,
      required this.submitDateT,
      required this.takeRecord,
      required this.employeeId,
      required this.status,
      required this.userId,
      required this.pageNumber,
      required this.rowNumber});

  Map<String, dynamic> toJson() => {
        "SkipRecord": skipRecord,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "TakeRecord": takeRecord,
        "employeeId": employeeId,
        "status": status,
        "userId": userId,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
