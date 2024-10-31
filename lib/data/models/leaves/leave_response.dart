class LeavePayload {
  List<LeaveResult>? result;
  int? totalPage;
  int? totalRecord;

  LeavePayload({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory LeavePayload.fromJson(Map<String, dynamic> json) => LeavePayload(
        result: json["result"] == null
            ? []
            : List<LeaveResult>.from(
                json["result"]!.map((x) => LeaveResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class LeaveResult {
  LeaveResult(
      {this.lvNo,
      this.submitDate,
      this.leaveType,
      this.leaveTypeDesc,
      this.leaveDays,
      this.fromDate,
      this.toDate,
      this.leaveStatus,
      this.leaveStatusDesc,
      this.marker});

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

  factory LeaveResult.fromJson(Map<String, dynamic> json) => LeaveResult(
      lvNo: json["lvNo"],
      submitDate: json["submitDate"],
      leaveType: json["leaveType"],
      leaveTypeDesc: json["leaveTypeDesc"],
      leaveDays: json["leaveDays"],
      fromDate: json["fromDate"],
      toDate: json["toDate"],
      leaveStatus: json["leaveStatus"],
      leaveStatusDesc: json["leaveStatusDesc"],
      marker: json["marker"]);
}
