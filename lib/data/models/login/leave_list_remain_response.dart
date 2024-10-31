import '../../data.dart';

class LeaveListRemainResponse {
  LeaveListRemainResponse(
      {required this.status,
      required this.leaveList,
      required this.svrPendingList,
      required this.interviewSchedule});

  List<Status> status;
  List<LeaveList> leaveList;
  List<RequestServiceResponse> svrPendingList;
  List<InterviewApprovalResult> interviewSchedule;

  factory LeaveListRemainResponse.fromJson(Map<String, dynamic> json) =>
      LeaveListRemainResponse(
        status:
            List<Status>.from(json["status"].map((x) => Status.fromJson(x))),
        leaveList: List<LeaveList>.from(
            json["leaveList"].map((x) => LeaveList.fromJson(x))),
        svrPendingList: json["status"] == null
            ? []
            : List<RequestServiceResponse>.from(json["pendingStatus"]
                .map((x) => RequestServiceResponse.fromJson(x))),
        interviewSchedule: json["interviewSchedule"] == null
            ? []
            : List<InterviewApprovalResult>.from(json["interviewSchedule"]
                .map((x) => InterviewApprovalResult.fromJson(x))),
      );
}

class LeaveList {
  LeaveList({
    required this.leaveTypeDesc,
    required this.leaveDays,
    required this.remains,
  });

  String? leaveTypeDesc;
  double? leaveDays;
  double? remains;

  factory LeaveList.fromJson(Map<String, dynamic> json) => LeaveList(
        leaveTypeDesc: json["leaveTypeDesc"],
        leaveDays: json["leaveDays"],
        remains: json["remains"],
      );
}

class Status {
  Status(
      {this.employeeName,
      this.dob,
      this.deptCode,
      this.deptDesc,
      this.divisionDesc,
      this.avartarThumbnail});

  String? employeeName;
  int? dob;
  String? deptCode;
  String? deptDesc;
  String? divisionDesc;
  String? avartarThumbnail;

  Status copyWith(
          {String? employeeName,
          int? dob,
          String? deptCode,
          String? deptDesc,
          String? divisionDesc,
          String? avartarThumbnail}) =>
      Status(
          employeeName: employeeName ?? this.employeeName,
          dob: dob ?? this.dob,
          deptCode: deptCode ?? this.deptCode,
          deptDesc: deptDesc ?? this.deptDesc,
          divisionDesc: divisionDesc ?? this.divisionDesc,
          avartarThumbnail: avartarThumbnail ?? this.avartarThumbnail);

  factory Status.fromJson(Map<String, dynamic> json) => Status(
      employeeName: json["employeeName"],
      dob: json["dob"],
      deptCode: json["deptCode"],
      deptDesc: json["deptDesc"],
      divisionDesc: json["divisionDesc"]!,
      avartarThumbnail: json["avartarThumbnail"]);
}
