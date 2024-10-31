class LeaveApprovalResponse {
  String? lvNo;
  int? submitDate;
  String? leaveType;
  String? leaveTypeDesc;
  double? leaveDays;
  int? fromDate;
  int? toDate;
  String? leaveStatus;
  String? leaveStatusDesc;
  String? marker;
  String? employeeName;
  dynamic updateDate;
  int? employeeId;
  String? leaveStatusDetail;

  LeaveApprovalResponse(
      {this.lvNo,
      this.submitDate,
      this.leaveType,
      this.leaveTypeDesc,
      this.leaveDays,
      this.fromDate,
      this.toDate,
      this.leaveStatus,
      this.leaveStatusDesc,
      this.marker,
      this.employeeName,
      this.updateDate,
      this.employeeId,
      this.leaveStatusDetail});

  factory LeaveApprovalResponse.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalResponse(
          lvNo: json["lvNo"],
          submitDate: json["submitDate"],
          leaveType: json["leaveType"],
          leaveTypeDesc: json["leaveTypeDesc"],
          leaveDays: json["leaveDays"],
          fromDate: json["fromDate"],
          toDate: json["toDate"],
          leaveStatus: json["leaveStatus"],
          leaveStatusDesc: json["leaveStatusDesc"],
          marker: json["marker"],
          employeeName: json["employeeName"],
          updateDate: json["updateDate"],
          employeeId: json["employeeId"],
          leaveStatusDetail: json["leaveStatusDetail"]);
}
