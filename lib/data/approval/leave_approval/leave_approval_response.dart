class LeaveApprovalResponse {
  List<LeaveApprovalResult>? result;
  int? totalPage;
  int? totalRecord;

  LeaveApprovalResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory LeaveApprovalResponse.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalResponse(
        result: json["result"] == null
            ? []
            : List<LeaveApprovalResult>.from(
                json["result"]!.map((x) => LeaveApprovalResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class LeaveApprovalResult {
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
  bool? selected;

  LeaveApprovalResult(
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
      this.leaveStatusDetail,
      this.selected});

  factory LeaveApprovalResult.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalResult(
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
          leaveStatusDetail: json["leaveStatusDetail"],
          selected: false);

  LeaveApprovalResult copyWith(
      {String? lvNo,
      int? submitDate,
      String? leaveType,
      String? leaveTypeDesc,
      double? leaveDays,
      int? fromDate,
      int? toDate,
      String? leaveStatus,
      String? leaveStatusDesc,
      String? marker,
      String? employeeName,
      dynamic updateDate,
      int? employeeId,
      String? leaveStatusDetail,
      bool? selected}) {
    return LeaveApprovalResult(
        lvNo: lvNo ?? this.lvNo,
        submitDate: submitDate ?? this.submitDate,
        leaveType: leaveType ?? this.leaveType,
        leaveTypeDesc: leaveTypeDesc ?? this.leaveTypeDesc,
        leaveDays: leaveDays ?? this.leaveDays,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        leaveStatus: leaveStatus ?? this.leaveStatus,
        leaveStatusDesc: leaveStatusDesc ?? this.leaveStatusDesc,
        marker: marker ?? this.marker,
        employeeName: employeeName ?? this.employeeName,
        updateDate: updateDate ?? this.updateDate,
        employeeId: employeeId ?? this.employeeId,
        leaveStatusDetail: leaveStatusDetail ?? this.leaveStatusDetail,
        selected: selected ?? this.selected);
  }
}
