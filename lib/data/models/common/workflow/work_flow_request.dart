class WorkFlowRequest {
  WorkFlowRequest(
      {required this.applicationCode,
      required this.deptCode,
      required this.divisionCode,
      required this.empId,
      required this.localAmount,
      required this.subsidiryId});

  String applicationCode;
  String deptCode;
  String divisionCode;
  String empId;
  int localAmount;
  String subsidiryId;

  Map<String, dynamic> toJson() => {
        "ApplicationCode": applicationCode,
        "DeptCode": deptCode,
        "DivisionCode": divisionCode,
        "EmpId": empId,
        "LocalAmount": localAmount,
        "SubsidiryID": subsidiryId
      };
}
