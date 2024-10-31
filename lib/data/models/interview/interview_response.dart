class InterviewApprovalResponse {
  List<InterviewApprovalResult>? result;
  int? totalPage;
  int? totalRecord;

  InterviewApprovalResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory InterviewApprovalResponse.fromJson(Map<String, dynamic> json) =>
      InterviewApprovalResponse(
        result: json["result"] == null
            ? []
            : List<InterviewApprovalResult>.from(json["result"]!
                .map((x) => InterviewApprovalResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class InterviewApprovalResult {
  String? cvName;
  String? positionTitle;
  String? facilityCode;
  int? hecviveeId;
  String? interviewTypeDesc;
  int? interviewDate;
  String? interviewType;
  int? interviewee;
  String? facilityDesc;
  int? hecvId;
  dynamic interviewRemark;
  int? updateDate;
  String? memo;
  String? intervieweeerName;
  String? facilityCodeDesc;

  InterviewApprovalResult(
      {this.cvName,
      this.positionTitle,
      this.facilityCode,
      this.hecviveeId,
      this.interviewTypeDesc,
      this.interviewDate,
      this.interviewType,
      this.interviewee,
      this.facilityDesc,
      this.hecvId,
      this.interviewRemark,
      this.updateDate,
      this.memo,
      this.intervieweeerName,
      this.facilityCodeDesc});

  factory InterviewApprovalResult.fromJson(Map<String, dynamic> json) =>
      InterviewApprovalResult(
          cvName: json["cvName"],
          positionTitle: json["positionTitle"],
          facilityCode: json["facilityCode"],
          hecviveeId: json["hecviveeId"],
          interviewTypeDesc: json["interviewTypeDesc"],
          interviewDate: json["interviewDate"],
          interviewType: json["interviewType"],
          interviewee: json["interviewee"],
          facilityDesc: json["facilityDesc"],
          hecvId: json["hecvId"],
          interviewRemark: json["interviewRemark"],
          updateDate: json["updateDate"],
          memo: json["memo"],
          intervieweeerName: json["intervieweeerName"],
          facilityCodeDesc: json["facilityCodeDesc"]);
}
