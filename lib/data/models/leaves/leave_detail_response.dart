class LeaveDetailPayload {
  LeaveDetailPayload(
      {this.lvNo,
      this.submitDate,
      this.fromDate,
      this.toDate,
      this.leaveTypeDesc,
      this.leaveType,
      this.leaveStatusDesc,
      this.ampmFull,
      this.leaveDays,
      this.remark,
      this.marker,
      this.leaveStatus,
      this.employeeName,
      this.approvalType,
      this.replyType,
      this.reasonCancel,
      this.documents,
      this.hlvLeaveDetails});

  String? lvNo;
  int? submitDate;
  int? fromDate;
  int? toDate;
  String? leaveTypeDesc;
  String? leaveType;
  String? leaveStatusDesc;
  String? ampmFull;
  double? leaveDays;
  String? remark;
  String? marker;
  String? leaveStatus;
  String? employeeName;
  dynamic approvalType;
  dynamic replyType;
  dynamic reasonCancel;
  List<dynamic>? documents;
  List<HlvLeaveDetail>? hlvLeaveDetails;

  factory LeaveDetailPayload.fromJson(Map<String, dynamic> json) =>
      LeaveDetailPayload(
          lvNo: json["lvNo"],
          submitDate: json["submitDate"],
          fromDate: json["fromDate"],
          toDate: json["toDate"],
          leaveTypeDesc: json["leaveTypeDesc"],
          leaveType: json["leaveType"],
          leaveStatusDesc: json["leaveStatusDesc"],
          ampmFull: json["ampmFull"],
          leaveDays: json["leaveDays"],
          remark: json["remark"],
          marker: json["marker"],
          leaveStatus: json["leaveStatus"],
          employeeName: json["employeeName"],
          approvalType: json["approvalType"],
          replyType: json["replyType"],
          reasonCancel: json["reasonCancel"],
          documents: List<dynamic>.from(json["documents"].map((x) => x)),
          hlvLeaveDetails: List<HlvLeaveDetail>.from(
              json["hlvLeaveDetails"].map((x) => HlvLeaveDetail.fromJson(x))));
}

class HlvLeaveDetail {
  HlvLeaveDetail(
      {this.replyItemNo,
      this.replyType,
      this.replyTypeDesc,
      this.comment,
      this.createDate,
      this.createUser,
      this.assignedUser,
      this.leaveStatus,
      this.leaveStatusDesc,
      this.approvalType,
      this.approvalTypeDesc,
      this.assignerName,
      this.hlvLeave});

  int? replyItemNo;
  String? replyType;
  String? replyTypeDesc;
  String? comment;
  int? createDate;
  dynamic createUser;
  int? assignedUser;
  String? leaveStatus;
  String? leaveStatusDesc;
  String? approvalType;
  String? approvalTypeDesc;
  String? assignerName;
  dynamic hlvLeave;

  factory HlvLeaveDetail.fromJson(Map<String, dynamic> json) => HlvLeaveDetail(
      replyItemNo: json["replyItemNo"],
      replyType: json["replyType"],
      replyTypeDesc: json["replyTypeDesc"],
      comment: json["comment"],
      createDate: json["createDate"],
      createUser: json["createUser"],
      assignedUser: json["assignedUser"],
      leaveStatus: json["leaveStatus"],
      leaveStatusDesc: json["leaveStatusDesc"],
      approvalType: json["approvalType"],
      approvalTypeDesc: json["approvalTypeDesc"],
      assignerName: json["assignerName"],
      hlvLeave: json["hlvLeave"]);
}
