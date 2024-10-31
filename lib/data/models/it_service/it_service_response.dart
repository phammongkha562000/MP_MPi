class ITServiceResponse {
  List<ITServiceResult>? result;
  int? totalPage;
  int? totalRecord;

  ITServiceResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory ITServiceResponse.fromJson(Map<String, dynamic> json) =>
      ITServiceResponse(
        result: json["result"] == null
            ? []
            : List<ITServiceResult>.from(
                json["result"]!.map((x) => ITServiceResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class ITServiceResult {
  ITServiceResult(
      {this.rownum,
      this.totalCount,
      this.isrNo,
      this.srSubject,
      this.postDate,
      this.itService,
      this.itServiceDesc,
      this.srStatus,
      this.srStatusDesc,
      this.dueDate,
      this.actualCompletion,
      this.closedDate,
      this.closedUser,
      this.subsidiaryId,
      this.subsidiaryName,
      this.createUser,
      this.department,
      this.division,
      this.assignTo});

  int? rownum;
  int? totalCount;
  String? isrNo;
  String? srSubject;
  int? postDate;
  String? itService;
  String? itServiceDesc;
  String? srStatus;
  String? srStatusDesc;
  dynamic dueDate;
  dynamic actualCompletion;
  dynamic closedDate;
  dynamic closedUser;
  String? subsidiaryId;
  String? subsidiaryName;
  String? createUser;
  String? department;
  String? division;
  dynamic assignTo;

  factory ITServiceResult.fromJson(Map<String, dynamic> json) =>
      ITServiceResult(
          rownum: json["rownum"],
          totalCount: json["totalCount"],
          isrNo: json["isrNo"],
          srSubject: json["srSubject"],
          postDate: json["postDate"],
          itService: json["itService"],
          itServiceDesc: json["itServiceDesc"],
          srStatus: json["srStatus"],
          srStatusDesc: json["srStatusDesc"],
          dueDate: json["dueDate"],
          actualCompletion: json["actualCompletion"],
          closedDate: json["closedDate"],
          closedUser: json["closedUser"],
          subsidiaryId: json["subsidiaryId"],
          subsidiaryName: json["subsidiaryName"],
          createUser: json["createUser"],
          department: json["department"],
          division: json["division"],
          assignTo: json["assignTo"]);
}
