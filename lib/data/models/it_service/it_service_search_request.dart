class ItServiceSearchRequest {
  ItServiceSearchRequest(
      {required this.details,
      required this.isrNo,
      required this.itService,
      required this.postDateF,
      required this.postDateT,
      required this.svcType,
      required this.createUserName,
      required this.subject,
      required this.subsidiaryId,
      required this.subsidiary,
      required this.status,
      required this.serviceType,
      required this.createdUser,
      required this.skipRecord,
      required this.takeRecord,
      required this.sortColumn,
      required this.sortOrder,
      required this.employeeId,
      required this.assignTo,
      required this.pageNumber,
      required this.rowNumber});

  String details;
  String isrNo;
  String itService;
  String postDateF;
  String postDateT;
  String svcType;
  String createUserName;
  String subject;
  String subsidiaryId;
  String subsidiary;
  String status;
  String serviceType;
  String createdUser;
  int skipRecord;
  int takeRecord;
  String sortColumn;
  String sortOrder;
  String employeeId;
  String assignTo;
  int pageNumber;
  int rowNumber;

  Map<String, dynamic> toJson() => {
        "Details": details,
        "ISRNo": isrNo,
        "ITService": itService,
        "PostDateF": postDateF,
        "PostDateT": postDateT,
        "SvcType": svcType,
        "CreateUserName": createUserName,
        "Subject": subject,
        "SubsidiaryId": subsidiaryId,
        "Subsidiary": subsidiary,
        "Status": status,
        "ServiceType": serviceType,
        "CreatedUser": createdUser,
        "SkipRecord": skipRecord,
        "TakeRecord": takeRecord,
        "SortColumn": sortColumn,
        "SortOrder": sortOrder,
        "employeeId": employeeId,
        "AssignTo": assignTo,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
