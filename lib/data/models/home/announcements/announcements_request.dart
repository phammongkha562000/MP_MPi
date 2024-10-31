class AnnouncementsRequest {
  final String employeeId;
  final String type;
  final String subject;
  final String dateFrom;
  final String dateTo;

  AnnouncementsRequest(
      {required this.employeeId,
      required this.type,
      required this.subject,
      required this.dateFrom,
      required this.dateTo});

  Map<String, dynamic> toJson() => {
        "EmployeeId": employeeId,
        "Type": type,
        "Subject": subject,
        "DateFrom": dateFrom,
        "DateTo": dateTo
      };
}
