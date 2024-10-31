class ServiceApprovalResponse {
  List<ServiceApprovalResult>? result;
  int? totalPage;
  int? totalRecord;

  ServiceApprovalResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory ServiceApprovalResponse.fromJson(Map<String, dynamic> json) =>
      ServiceApprovalResponse(
        result: json["result"] == null
            ? []
            : List<ServiceApprovalResult>.from(
                json["result"]!.map((x) => ServiceApprovalResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );
}

class ServiceApprovalResult {
  String? svrNo;
  String? svrSubject;
  String? svrServiceType;
  int? createDate;
  int? createUser;
  String? createUserName;
  dynamic updateDate;
  dynamic updateUser;
  String? svrStatus;
  int? dueDate;
  dynamic localDocAmount;
  dynamic usdDocAmount;
  dynamic thirdParty;
  dynamic background;
  String? requiredDetail;
  dynamic relatedCustomer;
  dynamic remark;
  String? proiority;
  String? hasBudget;
  String? subsidiaryId;
  String? divisionCode;
  dynamic refDocumentNo;
  dynamic deptCode;
  dynamic relatedDivision;
  int? approvedDate;
  String? application;
  String? svrStatusDesc;
  dynamic costCenterDesc;

  ServiceApprovalResult(
      {this.svrNo,
      this.svrSubject,
      this.svrServiceType,
      this.createDate,
      this.createUser,
      this.createUserName,
      this.updateDate,
      this.updateUser,
      this.svrStatus,
      this.dueDate,
      this.localDocAmount,
      this.usdDocAmount,
      this.thirdParty,
      this.background,
      this.requiredDetail,
      this.relatedCustomer,
      this.remark,
      this.proiority,
      this.hasBudget,
      this.subsidiaryId,
      this.divisionCode,
      this.refDocumentNo,
      this.deptCode,
      this.relatedDivision,
      this.approvedDate,
      this.application,
      this.svrStatusDesc,
      this.costCenterDesc});

  factory ServiceApprovalResult.fromJson(Map<String, dynamic> json) =>
      ServiceApprovalResult(
          svrNo: json["svrNo"],
          svrSubject: json["svrSubject"],
          svrServiceType: json["svrServiceType"],
          createDate: json["createDate"],
          createUser: json["createUser"],
          createUserName: json["createUserName"],
          updateDate: json["updateDate"],
          updateUser: json["updateUser"],
          svrStatus: json["svrStatus"],
          dueDate: json["dueDate"],
          localDocAmount: json["localDocAmount"],
          usdDocAmount: json["usdDocAmount"],
          thirdParty: json["thirdParty"],
          background: json["background"],
          requiredDetail: json["requiredDetail"],
          relatedCustomer: json["relatedCustomer"],
          remark: json["remark"],
          proiority: json["proiority"],
          hasBudget: json["hasBudget"],
          subsidiaryId: json["subsidiaryId"],
          divisionCode: json["divisionCode"],
          refDocumentNo: json["refDocumentNo"],
          deptCode: json["deptCode"],
          relatedDivision: json["relatedDivision"],
          approvedDate: json["approvedDate"],
          application: json["application"],
          svrStatusDesc: json["svrStatusDesc"],
          costCenterDesc: json["costCenterDesc"]);
}
