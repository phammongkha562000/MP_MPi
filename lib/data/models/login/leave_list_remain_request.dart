class LeaveListRemainRequest {
  final String subsidiaryId;
  final String employeeId;
  LeaveListRemainRequest(
      {required this.subsidiaryId, required this.employeeId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subsidiaryId': subsidiaryId,
      'employeeId': employeeId
    };
  }
}
