class AddServiceRequestRequest {
  final String hasBudget;
  final String svrSubject;
  final String svrServiceType;
  final String requiredDetail;
  final String proiority;
  final String svrStatus;
  final String dueDate;
  final String subsidiaryId;
  final int createUser;
  final String divisionCode;
  final String localDocAmount;
  final String usdDocAmount;
  final String remark;
  final String thirdParty;
  final String refDocumentNo;
  final String relatedDivision;
  AddServiceRequestRequest(
      {required this.hasBudget,
      required this.svrSubject,
      required this.svrServiceType,
      required this.requiredDetail,
      required this.proiority,
      required this.svrStatus,
      required this.dueDate,
      required this.subsidiaryId,
      required this.createUser,
      required this.divisionCode,
      required this.localDocAmount,
      required this.usdDocAmount,
      required this.remark,
      required this.thirdParty,
      required this.refDocumentNo,
      required this.relatedDivision});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'HasBudget': hasBudget,
      'svrSubject': svrSubject,
      'svrServiceType': svrServiceType,
      'requiredDetail': requiredDetail,
      'proiority': proiority,
      'svrStatus': svrStatus,
      'dueDate': dueDate,
      'subsidiaryId': subsidiaryId,
      'createUser': createUser,
      'divisionCode': divisionCode,
      'localDocAmount': localDocAmount,
      'usdDocAmount': usdDocAmount,
      'remark': remark,
      'thirdParty': thirdParty,
      'refDocumentNo': refDocumentNo,
      'relatedDivision': relatedDivision
    };
  }
}
