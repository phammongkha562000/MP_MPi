import '../../data.dart';

class ITServiceDetailResponse {
  ITServiceDetailResponse(
      {this.svcRequest, this.svcRequestDetails, this.attachments});

  SvcRequest? svcRequest;
  List<SvcRequestDetail>? svcRequestDetails;
  List<FileResponse>? attachments;

  ITServiceDetailResponse copyWith(
          {SvcRequest? svcRequest,
          List<SvcRequestDetail>? svcRequestDetails,
          List<FileResponse>? attachments}) =>
      ITServiceDetailResponse(
          svcRequest: svcRequest ?? this.svcRequest,
          svcRequestDetails: svcRequestDetails ?? this.svcRequestDetails,
          attachments: attachments ?? this.attachments);

  factory ITServiceDetailResponse.fromJson(Map<String, dynamic> json) =>
      ITServiceDetailResponse(
          svcRequest: SvcRequest.fromJson(json["svcRequest"]),
          svcRequestDetails: List<SvcRequestDetail>.from(
              json["svcRequestDetails"]
                  .map((x) => SvcRequestDetail.fromJson(x))),
          attachments: List<FileResponse>.from(
              json["attachments"].map((x) => FileResponse.fromJson(x))));
}

class SvcRequest {
  SvcRequest(
      {this.isrNo,
      this.srSubject,
      this.postDate,
      this.itService,
      this.itServiceDesc,
      this.serviceType,
      this.serviceTypeDesc,
      this.priority,
      this.pirorityDesc,
      this.srStatus,
      this.srStatusDesc,
      this.dueDate,
      this.actualCompletion,
      this.closedDate,
      this.closedUser,
      this.subsidiaryId,
      this.subsidiaryName,
      this.createUser,
      this.createDate,
      this.updaeUser,
      this.updateDate,
      this.details,
      this.createUserId});

  String? isrNo;
  String? srSubject;
  int? postDate;
  String? itService;
  String? itServiceDesc;
  String? serviceType;
  String? serviceTypeDesc;
  String? priority;
  String? pirorityDesc;
  String? srStatus;
  String? srStatusDesc;
  dynamic dueDate;
  dynamic actualCompletion;
  dynamic closedDate;
  dynamic closedUser;
  String? subsidiaryId;
  String? subsidiaryName;
  String? createUser;
  int? createDate;
  dynamic updaeUser;
  dynamic updateDate;
  String? details;
  int? createUserId;

  SvcRequest copyWith(
          {String? isrNo,
          String? srSubject,
          int? postDate,
          String? itService,
          String? itServiceDesc,
          String? serviceType,
          String? serviceTypeDesc,
          String? priority,
          String? pirorityDesc,
          String? srStatus,
          String? srStatusDesc,
          dynamic dueDate,
          dynamic actualCompletion,
          dynamic closedDate,
          dynamic closedUser,
          String? subsidiaryId,
          String? subsidiaryName,
          String? createUser,
          int? createDate,
          dynamic updaeUser,
          dynamic updateDate,
          String? details,
          int? createUserId}) =>
      SvcRequest(
          isrNo: isrNo ?? this.isrNo,
          srSubject: srSubject ?? this.srSubject,
          postDate: postDate ?? this.postDate,
          itService: itService ?? this.itService,
          itServiceDesc: itServiceDesc ?? this.itServiceDesc,
          serviceType: serviceType ?? this.serviceType,
          serviceTypeDesc: serviceTypeDesc ?? this.serviceTypeDesc,
          priority: priority ?? this.priority,
          pirorityDesc: pirorityDesc ?? this.pirorityDesc,
          srStatus: srStatus ?? this.srStatus,
          srStatusDesc: srStatusDesc ?? this.srStatusDesc,
          dueDate: dueDate ?? this.dueDate,
          actualCompletion: actualCompletion ?? this.actualCompletion,
          closedDate: closedDate ?? this.closedDate,
          closedUser: closedUser ?? this.closedUser,
          subsidiaryId: subsidiaryId ?? this.subsidiaryId,
          subsidiaryName: subsidiaryName ?? this.subsidiaryName,
          createUser: createUser ?? this.createUser,
          createDate: createDate ?? this.createDate,
          updaeUser: updaeUser ?? this.updaeUser,
          updateDate: updateDate ?? this.updateDate,
          details: details ?? this.details,
          createUserId: createUserId ?? this.createUserId);

  factory SvcRequest.fromJson(Map<String, dynamic> json) => SvcRequest(
      isrNo: json["isrNo"],
      srSubject: json["srSubject"],
      postDate: json["postDate"],
      itService: json["itService"],
      itServiceDesc: json["itServiceDesc"],
      serviceType: json["serviceType"],
      serviceTypeDesc: json["serviceTypeDesc"],
      priority: json["priority"],
      pirorityDesc: json["pirorityDesc"],
      srStatus: json["srStatus"],
      srStatusDesc: json["srStatusDesc"],
      dueDate: json["dueDate"],
      actualCompletion: json["actualCompletion"],
      closedDate: json["closedDate"],
      closedUser: json["closedUser"],
      subsidiaryId: json["subsidiaryId"],
      subsidiaryName: json["subsidiaryName"],
      createUser: json["createUser"],
      createDate: json["createDate"],
      updaeUser: json["updaeUser"],
      updateDate: json["updateDate"],
      details: json["details"],
      createUserId: json["createUserId"]);
}

class SvcRequestDetail {
  SvcRequestDetail(
      {this.isrrNo,
      this.details,
      this.createDate,
      this.createUser,
      this.updateDate,
      this.updateUser,
      this.srStatus,
      this.srStatusDesc,
      this.assignTo,
      this.avatarUser,
      this.attachments,
      this.createUserId});

  int? isrrNo;
  String? details;
  int? createDate;
  String? createUser;
  dynamic updateDate;
  dynamic updateUser;
  String? srStatus;
  String? srStatusDesc;
  String? assignTo;
  String? avatarUser;
  List<FileResponse>? attachments;
  int? createUserId;

  factory SvcRequestDetail.fromJson(Map<String, dynamic> json) =>
      SvcRequestDetail(
          isrrNo: json["isrrNo"],
          details: json["details"],
          createDate: json["createDate"],
          createUser: json["createUser"],
          updateDate: json["updateDate"],
          updateUser: json["updateUser"],
          srStatus: json["srStatus"],
          srStatusDesc: json["srStatusDesc"],
          assignTo: json["assignTo"],
          avatarUser: json["avatarUser"],
          attachments: json["attachments"] == null
              ? []
              : List<FileResponse>.from(
                  json["attachments"].map((x) => FileResponse.fromJson(x))),
          createUserId: json["createUserId"]);

  Map<String, dynamic> toJson() => {
        "isrrNo": isrrNo,
        "details": details,
        "createDate": createDate,
        "createUser": createUser,
        "updateDate": updateDate,
        "updateUser": updateUser,
        "srStatus": srStatus,
        "srStatusDesc": srStatusDesc,
        "assignTo": assignTo,
        "avatarUser": avatarUser,
        "attachments": attachments == null
            ? null
            : List<FileResponse>.from(attachments!.map((x) => x)),
        "createUserId": createUserId
      };
}
