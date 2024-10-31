class RecruitInterviewFormResponse {
  int? hecvId;
  String? nativePlace;
  String? permanentAddr;
  String? tempAddr;
  String? idNo;
  int? idIssueDate;
  String? placeOfIssue;
  String? marialStatus;
  String? availableDate;
  int? currentSalary;
  int? expectedSalary;
  dynamic salaryComment;
  String? educationLevel;
  String? languageAvailable;
  String? otherSkills;
  dynamic experience;
  dynamic interviewComment;
  dynamic schoolMajor;
  int? createDate;

  RecruitInterviewFormResponse(
      {this.hecvId,
      this.nativePlace,
      this.permanentAddr,
      this.tempAddr,
      this.idNo,
      this.idIssueDate,
      this.placeOfIssue,
      this.marialStatus,
      this.availableDate,
      this.currentSalary,
      this.expectedSalary,
      this.salaryComment,
      this.educationLevel,
      this.languageAvailable,
      this.otherSkills,
      this.experience,
      this.interviewComment,
      this.schoolMajor,
      this.createDate});

  factory RecruitInterviewFormResponse.fromJson(Map<String, dynamic> json) =>
      RecruitInterviewFormResponse(
          hecvId: json["hecvId"],
          nativePlace: json["nativePlace"],
          permanentAddr: json["permanentAddr"],
          tempAddr: json["tempAddr"],
          idNo: json["idNo"],
          idIssueDate: json["idIssueDate"],
          placeOfIssue: json["placeOfIssue"],
          marialStatus: json["marialStatus"],
          availableDate: json["availableDate"],
          currentSalary: json["currentSalary"],
          expectedSalary: json["expectedSalary"],
          salaryComment: json["salaryComment"],
          educationLevel: json["educationLevel"],
          languageAvailable: json["languageAvailable"],
          otherSkills: json["otherSkills"],
          experience: json["experience"],
          interviewComment: json["interviewComment"],
          schoolMajor: json["schoolMajor"],
          createDate: json["createDate"]);
}
