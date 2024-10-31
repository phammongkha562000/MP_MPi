class ServiceRequestDetailResponse {
  ServiceRequestDetailResponse({
    this.info,
    this.details,
    this.itemsDetail,
  });

  ServiceRequestInfo? info;
  List<ServiceRequestDetail>? details;
  dynamic itemsDetail;

  factory ServiceRequestDetailResponse.fromJson(Map<String, dynamic> json) =>
      ServiceRequestDetailResponse(
        info: json["info"] == null
            ? null
            : ServiceRequestInfo.fromJson(json["info"]),
        details: json["details"] == null
            ? []
            : List<ServiceRequestDetail>.from(
                json["details"]!.map((x) => ServiceRequestDetail.fromJson(x))),
        itemsDetail: json["itemsDetail"],
      );
}

class ServiceRequestDetail {
  ServiceRequestDetail({
    this.svrNo,
    this.itemNo,
    this.createDate,
    this.approveType,
    this.comment,
    this.namedRole,
    this.replyType,
    this.svrStatus,
    this.svrStatusDesc,
    this.createUser,
    this.assignedUser,
    this.createUserId,
    this.process,
  });

  String? svrNo;
  int? itemNo;
  int? createDate;
  dynamic approveType;
  dynamic comment;
  String? namedRole;
  String? replyType;
  String? svrStatus;
  String? svrStatusDesc;
  String? createUser;
  int? assignedUser;
  String? createUserId;
  String? process;

  factory ServiceRequestDetail.fromJson(Map<String, dynamic> json) =>
      ServiceRequestDetail(
        svrNo: json["svrNo"],
        itemNo: json["itemNo"],
        createDate: json["createDate"],
        approveType: json["approveType"],
        comment: json["comment"],
        namedRole: json["namedRole"],
        replyType: json["replyType"],
        svrStatus: json["svrStatus"],
        svrStatusDesc: json["svrStatusDesc"],
        createUser: json["createUser"],
        assignedUser: json["assignedUser"],
        createUserId: json["createUserId"],
        process: json["process"],
      );
}

class ServiceRequestInfo {
  ServiceRequestInfo({
    this.svrNo,
    this.svrSubject,
    this.svrServiceType,
    this.createDate,
    this.createUser,
    this.createUserName,
    this.updateDate,
    this.updateUser,
    this.isUse,
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
    this.divisionDesc,
    this.refDocumentNo,
    this.deptCode,
    this.relatedDivision,
    this.replyType,
    this.approveType,
    this.applicationDesc,
    this.namedRole,
    this.costCenterDesc,
  });

  String? svrNo;
  String? svrSubject;
  String? svrServiceType;
  int? createDate;
  int? createUser;
  String? createUserName;
  dynamic updateDate;
  dynamic updateUser;
  String? isUse;
  String? svrStatus;
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
  String? divisionDesc;
  String? refDocumentNo;
  dynamic deptCode;
  String? relatedDivision;
  String? replyType;
  String? approveType;
  String? applicationDesc;
  dynamic namedRole;
  dynamic costCenterDesc;

  factory ServiceRequestInfo.fromJson(Map<String, dynamic> json) =>
      ServiceRequestInfo(
        svrNo: json["svrNo"],
        svrSubject: json["svrSubject"],
        svrServiceType: json["svrServiceType"],
        createDate: json["createDate"],
        createUser: json["createUser"],
        createUserName: json["createUserName"],
        updateDate: json["updateDate"],
        updateUser: json["updateUser"],
        isUse: json["isUse"],
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
        divisionDesc: json["divisionDesc"],
        refDocumentNo: json["refDocumentNo"],
        deptCode: json["deptCode"],
        relatedDivision: json["relatedDivision"],
        replyType: json["replyType"],
        approveType: json["approveType"],
        applicationDesc: json["applicationDesc"],
        namedRole: json["namedRole"],
        costCenterDesc: json["costCenterDesc"],
      );
}
