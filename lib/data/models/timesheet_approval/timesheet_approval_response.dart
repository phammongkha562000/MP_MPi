class TimesheetApprovalResponse {
  List<TimesheetApprovalResult>? result;
  int? totalPage;
  int? totalRecord;

  TimesheetApprovalResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory TimesheetApprovalResponse.fromJson(Map<String, dynamic> json) =>
      TimesheetApprovalResponse(
        result: json["result"] == null
            ? []
            : List<TimesheetApprovalResult>.from(json["result"]!
                .map((x) => TimesheetApprovalResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class TimesheetApprovalResult {
  int? tsId;
  int? startTime;
  int? endTime;
  int? createDate;
  int? createUser;
  int? updateDate;
  int? updateUser;
  double? workHour;
  double? overtTimeHour;
  String? manualPostReason;
  String? manualPostType;
  int? employeeId;
  dynamic approvedBy;
  dynamic approveDate;
  String? isManualPost;
  dynamic approveType;
  dynamic approvedNameBy;
  String? tsStatus;
  String? tsStatusDesc;
  String? employeeName;
  dynamic approveComment;
  String? codeDesc;
  bool? selected;

  TimesheetApprovalResult(
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
      this.approveComment,
      this.codeDesc,
      this.selected});

  factory TimesheetApprovalResult.fromJson(Map<String, dynamic> json) =>
      TimesheetApprovalResult(
        tsId: json["tsId"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        createDate: json["createDate"],
        createUser: json["createUser"],
        updateDate: json["updateDate"],
        updateUser: json["updateUser"],
        workHour: json["workHour"]?.toDouble(),
        overtTimeHour: json["overtTimeHour"]?.toDouble(),
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
        approveComment: json["approveComment"],
        codeDesc: json["codeDesc"],
        selected: false,
      );

  TimesheetApprovalResult copyWith(
          {int? tsId,
          int? startTime,
          int? endTime,
          int? createDate,
          int? createUser,
          int? updateDate,
          int? updateUser,
          double? workHour,
          double? overtTimeHour,
          String? manualPostReason,
          String? manualPostType,
          int? employeeId,
          dynamic approvedBy,
          dynamic approveDate,
          String? isManualPost,
          dynamic approveType,
          dynamic approvedNameBy,
          String? tsStatus,
          String? tsStatusDesc,
          String? employeeName,
          dynamic approveComment,
          String? codeDesc,
          bool? selected}) =>
      TimesheetApprovalResult(
        tsId: tsId ?? this.tsId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        createDate: createDate ?? this.createDate,
        createUser: createUser ?? this.createUser,
        updateDate: updateDate ?? this.updateDate,
        updateUser: updateUser ?? this.updateUser,
        workHour: workHour ?? this.workHour,
        overtTimeHour: overtTimeHour ?? this.overtTimeHour,
        manualPostReason: manualPostReason ?? this.manualPostReason,
        manualPostType: manualPostType ?? this.manualPostType,
        employeeId: employeeId ?? this.employeeId,
        approvedBy: approvedBy ?? this.approvedBy,
        approveDate: approveDate ?? this.approveDate,
        isManualPost: isManualPost ?? this.isManualPost,
        approveType: approveType ?? this.approveType,
        approvedNameBy: approvedNameBy ?? this.approvedNameBy,
        tsStatus: tsStatus ?? this.tsStatus,
        tsStatusDesc: tsStatusDesc ?? this.tsStatusDesc,
        employeeName: employeeName ?? this.employeeName,
        approveComment: approveComment ?? this.approveComment,
        codeDesc: codeDesc ?? this.codeDesc,
        selected: selected ?? this.selected,
      );
}
