class WorkFlowResponse {
  WorkFlowResponse(
      {this.wkid,
      this.seqno,
      this.itemno,
      this.roleCode,
      this.roleDesc,
      this.namedRole,
      this.namedRoleDesc,
      this.conditionType,
      this.conditionValue1,
      this.conditionValue2,
      this.conditionValue3,
      this.conditionValue4,
      this.conditionMatchAction,
      this.namedRoleId,
      this.namedRoleName,
      this.email});

  int? wkid;
  int? seqno;
  int? itemno;
  String? roleCode;
  String? roleDesc;
  String? namedRole;
  String? namedRoleDesc;
  String? conditionType;
  String? conditionValue1;
  dynamic conditionValue2;
  String? conditionValue3;
  dynamic conditionValue4;
  String? conditionMatchAction;
  int? namedRoleId;
  String? namedRoleName;
  String? email;

  factory WorkFlowResponse.fromJson(Map<String, dynamic> json) =>
      WorkFlowResponse(
          wkid: json["wkid"],
          seqno: json["seqno"],
          itemno: json["itemno"],
          roleCode: json["roleCode"],
          roleDesc: json["roleDesc"],
          namedRole: json["namedRole"],
          namedRoleDesc: json["namedRoleDesc"],
          conditionType: json["conditionType"],
          conditionValue1: json["conditionValue1"],
          conditionValue2: json["conditionValue2"],
          conditionValue3: json["conditionValue3"],
          conditionValue4: json["conditionValue4"],
          conditionMatchAction: json["conditionMatchAction"],
          namedRoleId: json["namedRoleID"],
          namedRoleName: json["namedRoleName"],
          email: json["email"]);
}
