class UpdateInterviewRequest {
  String interviewRemark;
  String updateUser;
  int hecviveeId;

  UpdateInterviewRequest(
      {required this.interviewRemark,
      required this.updateUser,
      required this.hecviveeId});

  UpdateInterviewRequest copyWith(
          {String? interviewRemark, String? updateUser, int? hecviveeId}) =>
      UpdateInterviewRequest(
          interviewRemark: interviewRemark ?? this.interviewRemark,
          updateUser: updateUser ?? this.updateUser,
          hecviveeId: hecviveeId ?? this.hecviveeId);

  Map<String, dynamic> toJson() => {
        "InterviewRemark": interviewRemark,
        "UpdateUser": updateUser,
        "hecviveeId": hecviveeId
      };
}
