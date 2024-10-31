class TimesheetsRequest {
  TimesheetsRequest(
      {required this.status,
      required this.userId,
      required this.employeeId,
      required this.submitDateF,
      required this.submitDateT,
      required this.isCheckTime,
      required this.skipRecord,
      required this.takeRecord,
      required this.pageNumber,
      required this.rowNumber});

  String status;
  String userId;
  int employeeId;
  String submitDateF;
  String submitDateT;
  String isCheckTime;
  int skipRecord;
  int takeRecord;
  int pageNumber;
  int rowNumber;

  Map<String, dynamic> toJson() => {
        "status": status,
        "userId": userId,
        "employeeId": employeeId,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "IsCheckTime": isCheckTime,
        "SkipRecord": skipRecord,
        "TakeRecord": takeRecord,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
