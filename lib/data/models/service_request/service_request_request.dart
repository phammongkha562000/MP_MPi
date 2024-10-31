class ServiceRequestRequest {
  ServiceRequestRequest(
      {required this.type,
      required this.status,
      required this.submitDateF,
      required this.submitDateT,
      required this.userId,
      required this.skipRecord,
      required this.takeRecord,
      required this.pageNumber,
      required this.rowNumber});

  final String type;
  final String status;
  final String submitDateF;
  final String submitDateT;
  final int userId;
  final int skipRecord;
  final int takeRecord;
  final int pageNumber;
  final int rowNumber;
  Map<String, dynamic> toJson() => {
        "Type": type,
        "Status": status,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "UserId": userId,
        "SkipRecord": skipRecord,
        "TakeRecord": takeRecord,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
