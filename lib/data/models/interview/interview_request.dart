class InterviewApprovalRequest {
  final String employeeId;
  final String susidiaryId;
  final String dateF;
  final String dateT;
  final int pageNumber;
  final int rowNumber;

  InterviewApprovalRequest({
    required this.employeeId,
    required this.susidiaryId,
    required this.dateF,
    required this.dateT,
    required this.pageNumber,
    required this.rowNumber,
  });

  factory InterviewApprovalRequest.fromJson(Map<String, dynamic> json) =>
      InterviewApprovalRequest(
        employeeId: json["EmployeeId"],
        susidiaryId: json["SusidiaryId"],
        dateF: json["DateF"],
        dateT: json["DateT"],
        pageNumber: json["pageNumber"],
        rowNumber: json["rowNumber"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeId": employeeId,
        "SusidiaryId": susidiaryId,
        "DateF": dateF,
        "DateT": dateT,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber,
      };
}
