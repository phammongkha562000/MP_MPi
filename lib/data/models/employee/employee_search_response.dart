class EmployeeSearchResponse {
  List<EmployeeSearchResult>? result;
  int? totalPage;
  int? totalRecord;

  EmployeeSearchResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory EmployeeSearchResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeSearchResponse(
        result: json["result"] == null
            ? []
            : List<EmployeeSearchResult>.from(
                json["result"]!.map((x) => EmployeeSearchResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class EmployeeSearchResult {
  EmployeeSearchResult(
      {this.employeeId,
      this.employeeName,
      this.email,
      this.mobile,
      this.tel,
      this.dateofJoin,
      this.leftReason,
      this.subsidiaryName,
      this.divisionDesc,
      this.divisionCode,
      this.deptDesc,
      this.deptCode,
      this.designation,
      this.grade,
      this.leaveDate,
      this.employementType,
      this.avartarThumbnail,
      this.vehicle,
      this.vehicleNo,
      this.employeeCode,
      this.dob,
      this.employeeNote,
      this.address,
      this.workingLocation,
      this.idNo,
      this.timeSheetCode,
      this.gender});

  int? employeeId;
  String? employeeName;
  String? email;
  String? mobile;
  dynamic tel;
  int? dateofJoin;
  String? leftReason;
  String? subsidiaryName;
  String? divisionDesc;
  String? divisionCode;
  String? deptDesc;
  String? deptCode;
  String? designation;
  String? grade;
  dynamic leaveDate;
  String? employementType;
  String? avartarThumbnail;
  String? vehicle;
  String? vehicleNo;
  String? employeeCode;
  int? dob;
  String? employeeNote;
  String? address;
  String? workingLocation;
  String? idNo;
  String? timeSheetCode;
  String? gender;

  factory EmployeeSearchResult.fromJson(Map<String, dynamic> json) =>
      EmployeeSearchResult(
          employeeId: json["employeeId"],
          employeeName: json["employeeName"],
          email: json["email"],
          mobile: json["mobile"],
          tel: json["tel"],
          dateofJoin: json["dateofJoin"],
          leftReason: json["leftReason"],
          subsidiaryName: json["subsidiaryName"],
          divisionDesc: json["divisionDesc"],
          divisionCode: json["divisionCode"],
          deptDesc: json["deptDesc"],
          deptCode: json["deptCode"],
          designation: json["designation"],
          grade: json["grade"],
          leaveDate: json["leaveDate"],
          employementType: json["employementType"],
          avartarThumbnail: json["avartarThumbnail"],
          vehicle: json["vehicle"],
          vehicleNo: json["vehicleNo"],
          employeeCode: json["employeeCode"],
          dob: json["dob"],
          employeeNote: json["employeeNote"],
          address: json["address"],
          workingLocation: json["workingLocation"],
          idNo: json["idNo"],
          timeSheetCode: json["timeSheetCode"],
          gender: json["gender"]);
}
