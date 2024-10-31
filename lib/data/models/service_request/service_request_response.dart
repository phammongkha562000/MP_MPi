class ServiceRequestResponse {
  List<ServiceRequestResult>? result;
  int? totalPage;
  int? totalRecord;

  ServiceRequestResponse({
    this.result,
    this.totalPage,
    this.totalRecord,
  });

  factory ServiceRequestResponse.fromJson(Map<String, dynamic> json) =>
      ServiceRequestResponse(
        result: json["result"] == null
            ? []
            : List<ServiceRequestResult>.from(
                json["result"]!.map((x) => ServiceRequestResult.fromJson(x))),
        totalPage: json["totalPage"],
        totalRecord: json["totalRecord"],
      );

 
}

class ServiceRequestResult {
  ServiceRequestResult(
      {this.svrNo,
      this.svrSubject,
      this.svrServiceType,
      this.createDate,
      this.createUser,
      this.updateDate,
      this.updateUser,
      this.svrStatus,
      this.svrStatusDesc,
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
      this.vendor,
      this.vendorName,
      this.serviceCategory,
      this.serviceCategoryDesc,
      this.svrServiceTypeDesc,
      this.createUserName});

  String? svrNo;
  String? svrSubject;
  String? svrServiceType;
  int? createDate;
  int? createUser;
  dynamic updateDate;
  dynamic updateUser;
  String? svrStatus;
  String? svrStatusDesc;
  int? dueDate;
  double? localDocAmount;
  double? usdDocAmount;
  String? thirdParty;
  dynamic background;
  String? requiredDetail;
  dynamic relatedCustomer;
  String? remark;
  String? proiority;
  String? hasBudget;
  String? subsidiaryId;
  String? divisionCode;
  String? refDocumentNo;
  dynamic deptCode;
  String? relatedDivision;
  int? vendor;
  dynamic vendorName;
  dynamic serviceCategory;
  dynamic serviceCategoryDesc;
  String? svrServiceTypeDesc;
  String? createUserName;

  factory ServiceRequestResult.fromJson(Map<String, dynamic> json) =>
      ServiceRequestResult(
          svrNo: json["svrNo"],
          svrSubject: json["svrSubject"],
          svrServiceType: json["svrServiceType"],
          createDate: json["createDate"],
          createUser: json["createUser"],
          updateDate: json["updateDate"],
          updateUser: json["updateUser"],
          svrStatus: json["svrStatus"],
          svrStatusDesc: json["svrStatusDesc"],
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
          vendor: json["vendor"],
          vendorName: json["vendorName"],
          serviceCategory: json["serviceCategory"],
          serviceCategoryDesc: json["serviceCategoryDesc"],
          svrServiceTypeDesc: json["svrServiceTypeDesc"],
          createUserName: json["createUserName"]);
}
