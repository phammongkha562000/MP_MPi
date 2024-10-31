class CheckLeaveRequest {
  CheckLeaveRequest({this.leavetype, this.employeeId, this.lyear});

  String? leavetype;
  int? employeeId;
  String? lyear;

  Map<String, dynamic> toJson() =>
      {"leavetype": leavetype, "employeeId": employeeId, "lyear": lyear};
}
