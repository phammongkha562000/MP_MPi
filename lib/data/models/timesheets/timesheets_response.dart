class TimesheetResponse {
  List<TimesheetResult>? result;
  int? totalPage;
  int? totalRecord;

  TimesheetResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory TimesheetResponse.fromJson(Map<String, dynamic> json) =>
      TimesheetResponse(
        result: json["result"] == null
            ? []
            : List<TimesheetResult>.from(
                json["result"]!.map((x) => TimesheetResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class TimesheetResult {
  TimesheetResult(
      {this.tsId,
      this.startTime,
      this.endTime,
      this.createDate,
      this.createUser,
      this.updateDate,
      this.updateUser,
      this.workHour,
      this.overtTimeHour,
      this.manualPostReason,
      this.manualPostType,
      this.employeeId,
      this.approvedBy,
      this.approveDate,
      this.isManualPost,
      this.approveType,
      this.approvedNameBy,
      this.tsStatus,
      this.tsStatusDesc,
      this.employeeName,
      this.originalEndTime,
      this.originalStartTime,
      this.workDay});

  int? tsId;
  int? startTime;
  int? endTime;
  int? createDate;
  int? createUser;
  dynamic updateDate;
  dynamic updateUser;
  double? workHour;
  double? overtTimeHour;
  dynamic manualPostReason;
  dynamic manualPostType;
  int? employeeId;
  dynamic approvedBy;
  dynamic approveDate;
  String? isManualPost;
  dynamic approveType;
  dynamic approvedNameBy;
  String? tsStatus;
  String? tsStatusDesc;
  String? employeeName;
  dynamic originalEndTime;
  dynamic originalStartTime;
  double? workDay;

  factory TimesheetResult.fromJson(Map<String, dynamic> json) =>
      TimesheetResult(
          tsId: json["tsId"],
          startTime: json["startTime"],
          endTime: json["endTime"],
          createDate: json["createDate"],
          createUser: json["createUser"],
          updateDate: json["updateDate"],
          updateUser: json["updateUser"],
          workHour: json["workHour"],
          overtTimeHour: json["overtTimeHour"],
          manualPostReason: json["manualPostReason"],
          manualPostType: json["manualPostType"],
          employeeId: json["employeeId"],
          approvedBy: json["approvedBy"],
          approveDate: json["approveDate"],
          isManualPost: json["isManualPost"],
          approveType: json["approveType"],
          approvedNameBy: json["approvedNameBy"],
          tsStatus: json["tsStatus"],
          tsStatusDesc: json["tsStatusDesc"],
          employeeName: json["employeeName"],
          originalEndTime: json["originalEndTime"],
          originalStartTime: json["originalStartTime"],
          workDay: json["workDay"]);
}
