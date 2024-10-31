class WorkFlowRequest {
  WorkFlowRequest(
      {required this.deptCode,
      required this.divisionCode,
      required this.empId,
      required this.subsidiryId,
      required this.applicationCode,
      required this.localAmount});

  final String deptCode;
  final String divisionCode;
  final int empId;
  final String subsidiryId;
  final String applicationCode;
  final String localAmount;

  Map<String, dynamic> toJson() => {
        "DeptCode": deptCode,
        "DivisionCode": divisionCode,
        "EmpId": empId,
        "SubsidiryID": subsidiryId,
        "ApplicationCode": applicationCode,
        "LocalAmount": localAmount
      };
}
