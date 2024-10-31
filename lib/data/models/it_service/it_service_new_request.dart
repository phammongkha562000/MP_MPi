class CreateNewITServiceRequest {
  CreateNewITServiceRequest(
      {required this.createUser,
      required this.details,
      required this.subject,
      required this.subsidiaryId,
      required this.svcType,
      required this.iTService,
      required this.priority});

  String createUser;
  String details;
  String subject;
  String subsidiaryId;
  String svcType;
  String iTService;
  String priority;

  CreateNewITServiceRequest copyWith(
          {String? createUser,
          String? details,
          String? subject,
          String? subsidiaryId,
          String? svcType,
          String? iTService,
          String? priority}) =>
      CreateNewITServiceRequest(
          createUser: createUser ?? this.createUser,
          details: details ?? this.details,
          subject: subject ?? this.subject,
          subsidiaryId: subsidiaryId ?? this.subsidiaryId,
          svcType: svcType ?? this.svcType,
          iTService: iTService ?? this.iTService,
          priority: priority ?? this.priority);

  Map<String, dynamic> toJson() => {
        "CreateUser": createUser,
        "Details": details,
        "Subject": subject,
        "SubsidiaryId": subsidiaryId,
        "SvcType": svcType,
        "iTService": iTService,
        "priority": priority
      };
}
