class SaveServiceApprovalRequest {
  final String comment;
  final String approvalType;
  final int employeeId;
  final int userId;
  final String costCenter;
  final String hLvNo;

  SaveServiceApprovalRequest(
      {required this.comment,
      required this.approvalType,
      required this.employeeId,
      required this.userId,
      required this.costCenter,
      required this.hLvNo});

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "ApprovalType": approvalType,
        "EmployeeId": employeeId,
        "Userid": userId,
        "CostCenter": costCenter,
        "hLvNo": hLvNo
      };
}
