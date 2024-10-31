class HistoryInOutRequest {
  HistoryInOutRequest({required this.employeeId, required this.submitDateF});

  int employeeId;
  String submitDateF;

  Map<String, dynamic> toJson() =>
      {"EmployeeId": employeeId, "SubmitDateF": submitDateF};
}
