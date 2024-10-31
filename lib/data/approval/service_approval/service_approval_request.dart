class ServiceApprovalRequest {
  String? type;
  final String submitDateF;
  final String submitDateT;
  String? status;
  final int userId;
  dynamic isPending;
  String? costCenter;
  String? code;
  final int pageNumber;
  final int rowNumber;

  ServiceApprovalRequest(
      {this.type,
      required this.submitDateF,
      required this.submitDateT,
      this.status,
      required this.userId,
      required this.isPending,
      this.costCenter,
      this.code,
      required this.pageNumber,
      required this.rowNumber});

  Map<String, dynamic> toJson() => {
        "Type": type,
        "SubmitDateF": submitDateF,
        "SubmitDateT": submitDateT,
        "Status": status,
        "UserId": userId,
        "isPending": isPending,
        "CostCenter": costCenter,
        "Code": code,
        "pageNumber": pageNumber,
        "rowNumber": rowNumber
      };
}
