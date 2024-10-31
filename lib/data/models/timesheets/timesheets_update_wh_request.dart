class TimesheetsUpdateRequest {
  int tSId;
  String startTime;
  String endTime;
  double workHour;
  double overtTimeHour;
  String manualPostType;
  String manualPostReason;
  int updateUser;

  TimesheetsUpdateRequest(
      {required this.tSId,
      required this.startTime,
      required this.endTime,
      required this.workHour,
      required this.overtTimeHour,
      required this.manualPostType,
      required this.manualPostReason,
      required this.updateUser});

  Map<String, dynamic> toJson() => {
        "TSId": tSId,
        "StartTime": startTime,
        "EndTime": endTime,
        "WorkHour": workHour,
        "OvertTimeHour": overtTimeHour,
        "ManualPostType": manualPostType,
        "ManualPostReason": manualPostReason,
        "UpdateUser": updateUser,
      };
}
