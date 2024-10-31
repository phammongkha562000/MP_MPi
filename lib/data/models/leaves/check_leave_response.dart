class CheckLeaveResponse {
  CheckLeaveResponse(
      {this.leaveType,
      this.leaveTypeDesc,
      this.balance,
      this.used,
      this.entitled});

  String? leaveType;
  String? leaveTypeDesc;
  double? balance;
  double? used;
  double? entitled;

  factory CheckLeaveResponse.fromJson(Map<String, dynamic> json) =>
      CheckLeaveResponse(
          leaveType: json["leaveType"],
          leaveTypeDesc: json["leaveTypeDesc"],
          balance: json["balance"],
          used: json["used"],
          entitled: json["entitled"]);
}
